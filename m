Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E3F26779F
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Sep 2020 06:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgILEEy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 12 Sep 2020 00:04:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58497 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725795AbgILEEw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 12 Sep 2020 00:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599883489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/a8VrVJVX0l6jcxMYED7Y5gIXhQilXHoiWTwSpb4Xs=;
        b=TgbOvLBNycnKxRtbowdsKfWq2CasGpRg/lI7Kn4Kr/q4+FAR6t/63WKAGlayDxErGEYQym
        /QlRMBOPvSVa2O4KU85l6vD6AhArEG0pf3SzW9b+ooZzVwuzZFs/ellkw+w/LV7BVJ9C/s
        d+VA2gHvNa8breRuX0NvKaFGW0PTrMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-Bj8492-VOyqPxVEo8Y9XMA-1; Sat, 12 Sep 2020 00:04:46 -0400
X-MC-Unique: Bj8492-VOyqPxVEo8Y9XMA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6CFF801FC6;
        Sat, 12 Sep 2020 04:04:44 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B479F7B7A0;
        Sat, 12 Sep 2020 04:04:42 +0000 (UTC)
Subject: Re: [PATCH v5 0/2] ceph: metrics for opened files, pinned caps and
 opened inodes
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200903130140.799392-1-xiubli@redhat.com>
 <449a56624f3dd4e2a4a4cf95cd24d69c53700b6d.camel@kernel.org>
 <ad35f2f8-6692-3918-6137-adc8e95607c6@redhat.com>
 <CAOi1vP-8rbzZ=-Apir2B4Z6U10ZKrp41d6+BYgvGsyL+ND-JnQ@mail.gmail.com>
 <cdf40ea5-ecd0-0df6-7db4-7897aa3a5ad0@redhat.com>
 <CAOi1vP-XxXVcvyZgQF7mWaxm-21hiY5fF4tRYkua-F9ikof7UA@mail.gmail.com>
 <e291d899acee9f9218fe9a62f7300ab82592c459.camel@kernel.org>
 <9a5c5d2f-d105-21c4-327e-5ad18bf49518@redhat.com>
 <a281843181d1c97d099a2dd88c216ca94cf8d544.camel@kernel.org>
 <d174f7f99b4da9a2959b93bad622792fb693e495.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d71bf067-50ce-36f3-a627-409aff755a16@redhat.com>
Date:   Sat, 12 Sep 2020 12:04:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <d174f7f99b4da9a2959b93bad622792fb693e495.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/9/12 3:46, Jeff Layton wrote:
> On Fri, 2020-09-11 at 07:49 -0400, Jeff Layton wrote:
>> On Fri, 2020-09-11 at 11:43 +0800, Xiubo Li wrote:
>>> On 2020/9/10 20:13, Jeff Layton wrote:
>>>> On Thu, 2020-09-10 at 08:00 +0200, Ilya Dryomov wrote:
>>>>> On Thu, Sep 10, 2020 at 2:59 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>>>> On 2020/9/10 4:34, Ilya Dryomov wrote:
>>>>>>> On Thu, Sep 3, 2020 at 4:22 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>>>>> On 2020/9/3 22:18, Jeff Layton wrote:
>>>>>>>>> On Thu, 2020-09-03 at 09:01 -0400, xiubli@redhat.com wrote:
>>>>>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>>>>>
>>>>>>>>>> Changed in V5:
>>>>>>>>>> - Remove mdsc parsing helpers except the ceph_sb_to_mdsc()
>>>>>>>>>> - Remove the is_opened member.
>>>>>>>>>>
>>>>>>>>>> Changed in V4:
>>>>>>>>>> - A small fix about the total_inodes.
>>>>>>>>>>
>>>>>>>>>> Changed in V3:
>>>>>>>>>> - Resend for V2 just forgot one patch, which is adding some helpers
>>>>>>>>>> support to simplify the code.
>>>>>>>>>>
>>>>>>>>>> Changed in V2:
>>>>>>>>>> - Add number of inodes that have opened files.
>>>>>>>>>> - Remove the dir metrics and fold into files.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Xiubo Li (2):
>>>>>>>>>>       ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
>>>>>>>>>>       ceph: metrics for opened files, pinned caps and opened inodes
>>>>>>>>>>
>>>>>>>>>>      fs/ceph/caps.c    | 41 +++++++++++++++++++++++++++++++++++++----
>>>>>>>>>>      fs/ceph/debugfs.c | 11 +++++++++++
>>>>>>>>>>      fs/ceph/dir.c     | 20 +++++++-------------
>>>>>>>>>>      fs/ceph/file.c    | 13 ++++++-------
>>>>>>>>>>      fs/ceph/inode.c   | 11 ++++++++---
>>>>>>>>>>      fs/ceph/locks.c   |  2 +-
>>>>>>>>>>      fs/ceph/metric.c  | 14 ++++++++++++++
>>>>>>>>>>      fs/ceph/metric.h  |  7 +++++++
>>>>>>>>>>      fs/ceph/quota.c   | 10 +++++-----
>>>>>>>>>>      fs/ceph/snap.c    |  2 +-
>>>>>>>>>>      fs/ceph/super.h   |  6 ++++++
>>>>>>>>>>      11 files changed, 103 insertions(+), 34 deletions(-)
>>>>>>>>>>
>>>>>>>>> Looks good. I went ahead and merge this into testing.
>>>>>>>>>
>>>>>>>>> Small merge conflict in quota.c, which I guess is probably due to not
>>>>>>>>> basing this on testing branch. I also dropped what looks like an
>>>>>>>>> unrelated hunk in the second patch.
>>>>>>>>>
>>>>>>>>> In the future, if you can be sure that patches you post apply cleanly to
>>>>>>>>> testing branch then that would make things easier.
>>>>>>>> Okay, will do it.
>>>>>>> Hi Xiubo,
>>>>>>>
>>>>>>> There is a problem with lifetimes here.  mdsc isn't guaranteed to exist
>>>>>>> when ->free_inode() is called.  This can lead to crashes on a NULL mdsc
>>>>>>> in ceph_free_inode() in case of e.g. "umount -f".  I know it was Jeff's
>>>>>>> suggestion to move the decrement of total_inodes into ceph_free_inode(),
>>>>>>> but it doesn't look like it can be easily deferred past ->evict_inode().
>>>>>> Okay, I will take a look.
>>>>> Given that it's just a counter which we don't care about if the
>>>>> mount is going away, some form of "if (mdsc)" check might do, but
>>>>> need to make sure that it covers possible races, if any.
>>>>>
>>>> Good catch, Ilya.
>>>>
>>>> What may be best is to move the increment out of ceph_alloc_inode and
>>>> instead put it in ceph_set_ino_cb. Then the decrement can go back into
>>>> ceph_evict_inode.
>>> Hi Jeff, Ilya
>>>
>>> Checked the code, it seems in the ceph_evict_inode() we will also hit
>>> the same issue .
>>>
>>> With the '-f' options when umounting, it will skip the inodes whose
>>> i_count ref > 0. And then free the fsc/mdsc in ceph. And later the
>>> iput_final() will call the ceph_evict_inode() and then ceph_free_inode().
>>>
>>> Could we just check if !!(sb->s_flags & SB_ACTIVE) is false will we skip
>>> the counting ?
>>>
>> Note that umount -f (MNT_FORCE) just means that ceph_umount_begin is
>> called before unmounting.
>>
>> If what you're saying it true, then we have bigger problems.
>> ceph_evict_inode does this today when ci->i_snap_realm is set:
>>
>>      struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
>>
>> ...and then goes on to use that mdsc pointer.
>>
> Now that I look, I don't think that this is a problem. ceph_kill_sb
> calls generic_shutdown_super, which calls evict_inodes before the client
> is torn down. That should ensure that the mdsc is still good when evict
> is called.
>
> We will need to move the increment into the iget5_locked "set" function.
> Maybe we can squash the patch below into yours?

Yeah, the following patch looks good.

Thanks.


>
> ----------------------8<---------------------------
>
> ceph: use total_inodes to count hashed inodes instead of allocated ones
>
> We can't guarantee that the mdsc will still be around when free_inode is
> called, so move this into evict_inode instead. The increment then will
> need to be moved when the thing is hashed, so move that into the set
> callback.
>
> Reported-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/inode.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 5b9d2ff8af34..39c13fefba8a 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -42,10 +42,13 @@ static void ceph_inode_work(struct work_struct *work);
>   static int ceph_set_ino_cb(struct inode *inode, void *data)
>   {
>   	struct ceph_inode_info *ci = ceph_inode(inode);
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
>   
>   	ci->i_vino = *(struct ceph_vino *)data;
>   	inode->i_ino = ceph_vino_to_ino_t(ci->i_vino);
>   	inode_set_iversion_raw(inode, 0);
> +	percpu_counter_inc(&mdsc->metric.total_inodes);
> +
>   	return 0;
>   }
>   
> @@ -425,7 +428,6 @@ static int ceph_fill_fragtree(struct inode *inode,
>    */
>   struct inode *ceph_alloc_inode(struct super_block *sb)
>   {
> -	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
>   	struct ceph_inode_info *ci;
>   	int i;
>   
> @@ -525,17 +527,12 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>   
>   	ci->i_meta_err = 0;
>   
> -	percpu_counter_inc(&mdsc->metric.total_inodes);
> -
>   	return &ci->vfs_inode;
>   }
>   
>   void ceph_free_inode(struct inode *inode)
>   {
>   	struct ceph_inode_info *ci = ceph_inode(inode);
> -	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
> -
> -	percpu_counter_dec(&mdsc->metric.total_inodes);
>   
>   	kfree(ci->i_symlink);
>   	kmem_cache_free(ceph_inode_cachep, ci);
> @@ -544,11 +541,14 @@ void ceph_free_inode(struct inode *inode)
>   void ceph_evict_inode(struct inode *inode)
>   {
>   	struct ceph_inode_info *ci = ceph_inode(inode);
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
>   	struct ceph_inode_frag *frag;
>   	struct rb_node *n;
>   
>   	dout("evict_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
>   
> +	percpu_counter_dec(&mdsc->metric.total_inodes);
> +
>   	truncate_inode_pages_final(&inode->i_data);
>   	clear_inode(inode);
>   


