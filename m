Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC79F133DEA
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jan 2020 10:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgAHJJ3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jan 2020 04:09:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:33410 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727112AbgAHJJ3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 04:09:29 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 855672A8A9A212927650;
        Wed,  8 Jan 2020 17:09:25 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.213) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 8 Jan 2020
 17:09:23 +0800
Subject: Re: [PATCH v3] fs: Fix page_mkwrite off-by-one errors
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Jeff Layton <jlayton@kernel.org>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Artem Bityutskiy" <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <ceph-devel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-mtd@lists.infradead.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
References: <20191218130935.32402-1-agruenba@redhat.com>
 <20200107232031.GD472641@magnolia>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <e0b3d239-dd8a-de08-3b1b-42a2eb2b366f@huawei.com>
Date:   Wed, 8 Jan 2020 17:09:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200107232031.GD472641@magnolia>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/8 7:20, Darrick J. Wong wrote:
> On Wed, Dec 18, 2019 at 02:09:35PM +0100, Andreas Gruenbacher wrote:
>> Hi Darrick,
>>
>> can this fix go in via the xfs tree?
>>
>> Thanks,
>> Andreas
>>
>> --
>>
>> The check in block_page_mkwrite that is meant to determine whether an
>> offset is within the inode size is off by one.  This bug has been copied
>> into iomap_page_mkwrite and several filesystems (ubifs, ext4, f2fs,
>> ceph).
>>
>> Fix that by introducing a new page_mkwrite_check_truncate helper that
>> checks for truncate and computes the bytes in the page up to EOF.  Use
>> the helper in the above mentioned filesystems.
>>
>> In addition, use the new helper in btrfs as well.
>>
>> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>> Acked-by: David Sterba <dsterba@suse.com> (btrfs part)
>> Acked-by: Richard Weinberger <richard@nod.at> (ubifs part)
>> ---
>>  fs/btrfs/inode.c        | 15 ++++-----------
>>  fs/buffer.c             | 16 +++-------------
>>  fs/ceph/addr.c          |  2 +-
>>  fs/ext4/inode.c         | 14 ++++----------
>>  fs/f2fs/file.c          | 19 +++++++------------
> 
> Well, the f2fs developers never acked this and there was a conflict when
> I put this into for-next, so I removed the f2fs part (and fixed the
> unused variable warning in the ext4 part)...

Sorry for late reply.

Acked-by: Chao Yu <yuchao0@huawei.com>

BTW, to avoid such conflict, does f2fs need to rebase/fix its last code
on current patch?

Thanks,

> 
> --D
> 
>>  fs/iomap/buffered-io.c  | 18 +++++-------------
>>  fs/ubifs/file.c         |  3 +--
>>  include/linux/pagemap.h | 28 ++++++++++++++++++++++++++++
>>  8 files changed, 53 insertions(+), 62 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 56032c518b26..86c6fcd8139d 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -9016,13 +9016,11 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>>  	ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
>>  again:
>>  	lock_page(page);
>> -	size = i_size_read(inode);
>>  
>> -	if ((page->mapping != inode->i_mapping) ||
>> -	    (page_start >= size)) {
>> -		/* page got truncated out from underneath us */
>> +	ret2 = page_mkwrite_check_truncate(page, inode);
>> +	if (ret2 < 0)
>>  		goto out_unlock;
>> -	}
>> +	zero_start = ret2;
>>  	wait_on_page_writeback(page);
>>  
>>  	lock_extent_bits(io_tree, page_start, page_end, &cached_state);
>> @@ -9043,6 +9041,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>>  		goto again;
>>  	}
>>  
>> +	size = i_size_read(inode);
>>  	if (page->index == ((size - 1) >> PAGE_SHIFT)) {
>>  		reserved_space = round_up(size - page_start,
>>  					  fs_info->sectorsize);
>> @@ -9075,12 +9074,6 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>>  	}
>>  	ret2 = 0;
>>  
>> -	/* page is wholly or partially inside EOF */
>> -	if (page_start + PAGE_SIZE > size)
>> -		zero_start = offset_in_page(size);
>> -	else
>> -		zero_start = PAGE_SIZE;
>> -
>>  	if (zero_start != PAGE_SIZE) {
>>  		kaddr = kmap(page);
>>  		memset(kaddr + zero_start, 0, PAGE_SIZE - zero_start);
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index d8c7242426bb..53aabde57ca7 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -2499,23 +2499,13 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>>  	struct page *page = vmf->page;
>>  	struct inode *inode = file_inode(vma->vm_file);
>>  	unsigned long end;
>> -	loff_t size;
>>  	int ret;
>>  
>>  	lock_page(page);
>> -	size = i_size_read(inode);
>> -	if ((page->mapping != inode->i_mapping) ||
>> -	    (page_offset(page) > size)) {
>> -		/* We overload EFAULT to mean page got truncated */
>> -		ret = -EFAULT;
>> +	ret = page_mkwrite_check_truncate(page, inode);
>> +	if (ret < 0)
>>  		goto out_unlock;
>> -	}
>> -
>> -	/* page is wholly or partially inside EOF */
>> -	if (((page->index + 1) << PAGE_SHIFT) > size)
>> -		end = size & ~PAGE_MASK;
>> -	else
>> -		end = PAGE_SIZE;
>> +	end = ret;
>>  
>>  	ret = __block_write_begin(page, 0, end, get_block);
>>  	if (!ret)
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 7ab616601141..ef958aa4adb4 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -1575,7 +1575,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
>>  	do {
>>  		lock_page(page);
>>  
>> -		if ((off > size) || (page->mapping != inode->i_mapping)) {
>> +		if (page_mkwrite_check_truncate(page, inode) < 0) {
>>  			unlock_page(page);
>>  			ret = VM_FAULT_NOPAGE;
>>  			break;
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 28f28de0c1b6..51ab1d2cac80 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -5871,7 +5871,6 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
>>  {
>>  	struct vm_area_struct *vma = vmf->vma;
>>  	struct page *page = vmf->page;
>> -	loff_t size;
>>  	unsigned long len;
>>  	int err;
>>  	vm_fault_t ret;
>> @@ -5907,18 +5906,13 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
>>  	}
>>  
>>  	lock_page(page);
>> -	size = i_size_read(inode);
>> -	/* Page got truncated from under us? */
>> -	if (page->mapping != mapping || page_offset(page) > size) {
>> +	err = page_mkwrite_check_truncate(page, inode);
>> +	if (err < 0) {
>>  		unlock_page(page);
>> -		ret = VM_FAULT_NOPAGE;
>> -		goto out;
>> +		goto out_ret;
>>  	}
>> +	len = err;
>>  
>> -	if (page->index == size >> PAGE_SHIFT)
>> -		len = size & ~PAGE_MASK;
>> -	else
>> -		len = PAGE_SIZE;
>>  	/*
>>  	 * Return if we have all the buffers mapped. This avoids the need to do
>>  	 * journal_start/journal_stop which can block and take a long time
>> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
>> index 85af112e868d..0e77b2e6f873 100644
>> --- a/fs/f2fs/file.c
>> +++ b/fs/f2fs/file.c
>> @@ -51,7 +51,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
>>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>>  	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
>>  	struct dnode_of_data dn = { .node_changed = false };
>> -	int err;
>> +	int offset, err;
>>  
>>  	if (unlikely(f2fs_cp_error(sbi))) {
>>  		err = -EIO;
>> @@ -70,13 +70,14 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
>>  	file_update_time(vmf->vma->vm_file);
>>  	down_read(&F2FS_I(inode)->i_mmap_sem);
>>  	lock_page(page);
>> -	if (unlikely(page->mapping != inode->i_mapping ||
>> -			page_offset(page) > i_size_read(inode) ||
>> -			!PageUptodate(page))) {
>> +	err = -EFAULT;
>> +	if (likely(PageUptodate(page)))
>> +		err = page_mkwrite_check_truncate(page, inode);
>> +	if (unlikely(err < 0)) {
>>  		unlock_page(page);
>> -		err = -EFAULT;
>>  		goto out_sem;
>>  	}
>> +	offset = err;
>>  
>>  	/* block allocation */
>>  	__do_map_lock(sbi, F2FS_GET_BLOCK_PRE_AIO, true);
>> @@ -101,14 +102,8 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
>>  	if (PageMappedToDisk(page))
>>  		goto out_sem;
>>  
>> -	/* page is wholly or partially inside EOF */
>> -	if (((loff_t)(page->index + 1) << PAGE_SHIFT) >
>> -						i_size_read(inode)) {
>> -		loff_t offset;
>> -
>> -		offset = i_size_read(inode) & ~PAGE_MASK;
>> +	if (offset != PAGE_SIZE)
>>  		zero_user_segment(page, offset, PAGE_SIZE);
>> -	}
>>  	set_page_dirty(page);
>>  	if (!PageUptodate(page))
>>  		SetPageUptodate(page);
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index d33c7bc5ee92..1aaf157fd6e9 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -1062,24 +1062,16 @@ vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
>>  	struct page *page = vmf->page;
>>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>>  	unsigned long length;
>> -	loff_t offset, size;
>> +	loff_t offset;
>>  	ssize_t ret;
>>  
>>  	lock_page(page);
>> -	size = i_size_read(inode);
>> -	offset = page_offset(page);
>> -	if (page->mapping != inode->i_mapping || offset > size) {
>> -		/* We overload EFAULT to mean page got truncated */
>> -		ret = -EFAULT;
>> +	ret = page_mkwrite_check_truncate(page, inode);
>> +	if (ret < 0)
>>  		goto out_unlock;
>> -	}
>> -
>> -	/* page is wholly or partially inside EOF */
>> -	if (offset > size - PAGE_SIZE)
>> -		length = offset_in_page(size);
>> -	else
>> -		length = PAGE_SIZE;
>> +	length = ret;
>>  
>> +	offset = page_offset(page);
>>  	while (length > 0) {
>>  		ret = iomap_apply(inode, offset, length,
>>  				IOMAP_WRITE | IOMAP_FAULT, ops, page,
>> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
>> index cd52585c8f4f..91f7a1f2db0d 100644
>> --- a/fs/ubifs/file.c
>> +++ b/fs/ubifs/file.c
>> @@ -1563,8 +1563,7 @@ static vm_fault_t ubifs_vm_page_mkwrite(struct vm_fault *vmf)
>>  	}
>>  
>>  	lock_page(page);
>> -	if (unlikely(page->mapping != inode->i_mapping ||
>> -		     page_offset(page) > i_size_read(inode))) {
>> +	if (unlikely(page_mkwrite_check_truncate(page, inode) < 0)) {
>>  		/* Page got truncated out from underneath us */
>>  		goto sigbus;
>>  	}
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 37a4d9e32cd3..ccb14b6a16b5 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -636,4 +636,32 @@ static inline unsigned long dir_pages(struct inode *inode)
>>  			       PAGE_SHIFT;
>>  }
>>  
>> +/**
>> + * page_mkwrite_check_truncate - check if page was truncated
>> + * @page: the page to check
>> + * @inode: the inode to check the page against
>> + *
>> + * Returns the number of bytes in the page up to EOF,
>> + * or -EFAULT if the page was truncated.
>> + */
>> +static inline int page_mkwrite_check_truncate(struct page *page,
>> +					      struct inode *inode)
>> +{
>> +	loff_t size = i_size_read(inode);
>> +	pgoff_t index = size >> PAGE_SHIFT;
>> +	int offset = offset_in_page(size);
>> +
>> +	if (page->mapping != inode->i_mapping)
>> +		return -EFAULT;
>> +
>> +	/* page is wholly inside EOF */
>> +	if (page->index < index)
>> +		return PAGE_SIZE;
>> +	/* page is wholly past EOF */
>> +	if (page->index > index || !offset)
>> +		return -EFAULT;
>> +	/* page is partially inside EOF */
>> +	return offset;
>> +}
>> +
>>  #endif /* _LINUX_PAGEMAP_H */
>> -- 
>> 2.20.1
>>
> .
> 
