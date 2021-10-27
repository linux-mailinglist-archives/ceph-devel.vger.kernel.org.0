Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F2143D772
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 01:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbhJ0XZw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 19:25:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229437AbhJ0XZv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 19:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635377004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i/3S1uSYLWiapcfJMgQtg1lqjfYKdagiM47Apr1qNlU=;
        b=f/c+5Bs9WwbD7jF4JOYORCJLE9b++WC4HNmbFJrX7s5aXPSd5Kb/UbjPTkxxwQqPrFfG6u
        0iEE4oLcLR6VKqdwL7oOhtJSXaX9foVnVDDOpm8IgQphhCUmoAg2dTvkB7f1qUgxGm+4mI
        43uIX3AyQA5x0qihHkfjmZ2pMRcRNpo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-D_P35lC-ON-Wc6Vo6Euyzg-1; Wed, 27 Oct 2021 19:23:23 -0400
X-MC-Unique: D_P35lC-ON-Wc6Vo6Euyzg-1
Received: by mail-pl1-f199.google.com with SMTP id w8-20020a170902a70800b0013ffaf12fbaso1758787plq.23
        for <ceph-devel@vger.kernel.org>; Wed, 27 Oct 2021 16:23:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=i/3S1uSYLWiapcfJMgQtg1lqjfYKdagiM47Apr1qNlU=;
        b=gi85OUCH/eFs7BYB7siYuB40RFVJrkuGNrEV4iuSJKMLZfqB6ymnilXrWSsVZZFss2
         2W4vli2YHQdTAnu6Jj6euZ8PHjSwsXXNoxdHdZgySiaCQYvK4vcG1UiykKKmXpjFJDOY
         fu+Yky+lH5Idp9yRn3YBiKdYq6XVHoSBy7rW6vr58VW0suFHbsJYMomkn16AbvbEUgd/
         j370pd53MCnUGpzYkaIk5IBe9pEitDHorDc9/FGbVjdnTmX1/kdlF7PUUVcjFp3c0akm
         Et096JPMMUsjzFjMkriJLL0e0ANKU1im2UIGQkhX/x47cqS/bPlnFTvxoQHaWztOWotr
         RD5w==
X-Gm-Message-State: AOAM533kk73B3ePGlhxuFhDzQtxfdH+tKr2noGJdD5N4lXcJati/cN+l
        aUZMRlct/c8bZXr/M08kRaRrsxmxPtnwXXdF/XOKoDRWolhz6fb69EDdDjtPoarchMQIa9cDlqg
        BtBrzUVQMA2lj9Kyet07LjzwmiLR7hdSG1JdcNDnScVtx/GC5eO2Mydyj+q0TvV3ugnGUdbE=
X-Received: by 2002:a65:648b:: with SMTP id e11mr580798pgv.138.1635377001454;
        Wed, 27 Oct 2021 16:23:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1TJxHxMzIJzF8DOcN1ZH8oNhHGcuUp4Vkb+gWRIrVImLpHqmi+x/GtUM9I67fEKkbHkzWBw==
X-Received: by 2002:a65:648b:: with SMTP id e11mr580761pgv.138.1635377000939;
        Wed, 27 Oct 2021 16:23:20 -0700 (PDT)
Received: from [10.72.12.20] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t40sm1061062pfg.142.2021.10.27.16.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 16:23:20 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] ceph: add truncate size handling support for
 fscrypt
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20211020132813.543695-1-xiubli@redhat.com>
 <20211020132813.543695-5-xiubli@redhat.com>
 <d3ffc19d0b3f20a56d49428a486acfd9d6b22001.camel@kernel.org>
 <8086334a-cf2a-44b7-eb79-6f9734e1f5a1@redhat.com>
Message-ID: <8f86b5c7-f23d-01b0-690e-90e6378f722b@redhat.com>
Date:   Thu, 28 Oct 2021 07:23:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <8086334a-cf2a-44b7-eb79-6f9734e1f5a1@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/26/21 11:41 AM, Xiubo Li wrote:
>
> On 10/26/21 4:01 AM, Jeff Layton wrote:
>> On Wed, 2021-10-20 at 21:28 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> This will transfer the encrypted last block contents to the MDS
>>> along with the truncate request only when new size is smaller and
>>> not aligned to the fscrypt BLOCK size.
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/caps.c  |   9 +--
>>>   fs/ceph/inode.c | 210 
>>> ++++++++++++++++++++++++++++++++++++++++++------
>>>   2 files changed, 190 insertions(+), 29 deletions(-)
>>>
...
>>> +fill_last_block:
>>> +    pagelist = ceph_pagelist_alloc(GFP_KERNEL);
>>> +    if (!pagelist)
>>> +        return -ENOMEM;
>>> +
>>> +    /* Insert the header first */
>>> +    header.ver = 1;
>>> +    header.compat = 1;
>>> +    /* sizeof(file_offset) + sizeof(block_size) + blen */
>>> +    header.data_len = cpu_to_le32(8 + 8 + CEPH_FSCRYPT_BLOCK_SIZE);
>>> +    header.file_offset = cpu_to_le64(orig_pos);
>>> +    if (fill_header_only) {
>>> +        header.file_offset = cpu_to_le64(0);
>>> +        header.block_size = cpu_to_le64(0);
>>> +    } else {
>>> +        header.file_offset = cpu_to_le64(orig_pos);
>>> +        header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
>>> +    }
>>> +    ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
>>> +    if (ret)
>>> +        goto out;
>>>
>>>
>> Note that you're doing a read/modify/write cycle, and you must ensure
>> that the object remains consistent between the read and write or you may
>> end up with data corruption. This means that you probably need to
>> transmit an object version as part of the write. See this patch in the
>> stack:
>>
>>      libceph: add CEPH_OSD_OP_ASSERT_VER support
>>
>> That op tells the OSD to stop processing the request if the version is
>> wrong.
>>
>> You'll want to grab the "ver" from the __ceph_sync_read call, and then
>> send that along with the updated last block. Then, when the MDS is
>> truncating, it can use a CEPH_OSD_OP_ASSERT_VER op with that version to
>> ensure that the object hasn't changed when doing it. If the assertion
>> trips, then the MDS should send back EAGAIN or something similar to the
>> client to tell it to retry.
>
> Yeah, this is one issues I have mentioned in the cover-letter, I found 
> the cover-letter wasn't successfully sent to the mail list.
>
> Except this, there also has another isssue, I will pasted some 
> important sections here from the cover-letter:
>
> ======
>
> This approach is based on the discussion from V1, which will pass
> the encrypted last block contents to MDS along with the truncate
> request.
>
> This will send the encrypted last block contents to MDS along with
> the truncate request when truncating to a smaller size and at the
> same time new size does not align to BLOCK SIZE.
>
> The MDS side patch is raised in PR
> https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
> previous great work in PR https://github.com/ceph/ceph/pull/41284.
>
> The MDS will use the filer.write_trunc(), which could update and
> truncate the file in one shot, instead of filer.truncate().
>
> I have removed the inline data related code since we are remove
> this feature, more detail please see:
> https://tracker.ceph.com/issues/52916
>
>
> Note: There still has two CORNER cases we need to deal with:
>
> 1), If a truncate request with the last block is sent to the MDS and
> just before the MDS has acquired the xlock for FILE lock, if another
> client has updated that last block content, we will over write the
> last block with old data.
>
> For this case we could send the old encrypted last block data along
> with the truncate request and in MDS side read it and then do compare
> just before updating it, if the comparasion fails, then fail the
> truncate and let the kclient retry it.
>
> 2), If another client has buffered the last block, we should flush
> it first. I am still thinking how to do this ? Any idea is welcome.
>
Checked more about the MDS locker related code, once we get the Fr caps 
in the kclient which is doing the truncate, the Fb caps will be revoked 
by the MDS already. It's not allowed that one client hold Fr cap, and 
another client will hold the Fb. So we don't worry about the last block 
will still be buffered by another kclient once we get the Fr caps.

But it's possible that if currently kclient is a loner, it could have 
already buffered the last block in pagecache, since we need the 
assert_ver from the Rados for the truncate, so we couldn't get the 
contents from the pagecache and we need to flush the pagecache first and 
read it again from Rados.

BRs

-- Xiubo


> ======
>
> For the first issue, I will check the "CEPH_OSD_OP_ASSERT_VER".
>
> For the second issue, I think the "CEPH_OSD_OP_ASSERT_VER" could work 
> too. When the MDS has successfully xlocked the FILE lock, we could 
> notify the kclients to flush the buffer first, and then try to 
> write/truncate the file, if it fails due to the 
> "CEPH_OSD_OP_ASSERT_VER" check, then let kclient retry the truncate 
> request.
>
> NOTE: All the xlock and xlock related interim states allowed the 
> clients continue to hold the Fcb caps which are issued from previous 
> states, except that the LOCK_XLOCKSNAP only allow clients to hold Fc.
>
>
>>
>> It's also possible (though I've never used it) to make an OSD request
>> assert that the contents of an extent haven't changed, so you could
>> instead send along the old contents along with the new ones, etc.
>>
>> That may end up being more efficient if the object is getting hammered
>> with I/O in other fscrypt blocks within the same object. It may be worth
>> exploring that avenue as well.
>>
>>> +
>>> +    if (!fill_header_only) {
>>> +        /* Append the last block contents to pagelist */
>>> +        for (i = 0; i < num_pages; i++) {
>>> +            ret = ceph_pagelist_append(pagelist, iovs[i].iov_base,
>>> +                           blen);
>>> +            if (ret)
>>> +                goto out;
>>> +        }
>>> +    }
>>> +    req->r_pagelist = pagelist;
>>> +out:
>>> +    dout("%s %p size dropping cap refs on %s\n", __func__,
>>> +         inode, ceph_cap_string(got));
>>> +    for (i = 0; iovs && i < num_pages; i++)
>>> +        kunmap_local(iovs[i].iov_base);
>>> +    kfree(iovs);
>>> +    if (pages)
>>> +        ceph_release_page_vector(pages, num_pages);
>>> +    if (ret && pagelist)
>>> +        ceph_pagelist_release(pagelist);
>>> +    ceph_put_cap_refs(ci, got);
>>> +    return ret;
>>> +}
>>> +
>>>   int __ceph_setattr(struct inode *inode, struct iattr *attr, struct 
>>> ceph_iattr *cia)
>>>   {
>>>       struct ceph_inode_info *ci = ceph_inode(inode);
>>> @@ -2236,6 +2391,7 @@ int __ceph_setattr(struct inode *inode, struct 
>>> iattr *attr, struct ceph_iattr *c
>>>       struct ceph_mds_request *req;
>>>       struct ceph_mds_client *mdsc = 
>>> ceph_sb_to_client(inode->i_sb)->mdsc;
>>>       struct ceph_cap_flush *prealloc_cf;
>>> +    loff_t isize = i_size_read(inode);
>>>       int issued;
>>>       int release = 0, dirtied = 0;
>>>       int mask = 0;
>>> @@ -2367,10 +2523,31 @@ int __ceph_setattr(struct inode *inode, 
>>> struct iattr *attr, struct ceph_iattr *c
>>>           }
>>>       }
>>>       if (ia_valid & ATTR_SIZE) {
>>> -        loff_t isize = i_size_read(inode);
>>> -
>>>           dout("setattr %p size %lld -> %lld\n", inode, isize, 
>>> attr->ia_size);
>>> -        if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
>>> +        /*
>>> +         * Only when the new size is smaller and not aligned to
>>> +         * CEPH_FSCRYPT_BLOCK_SIZE will the RMW is needed.
>>> +         */
>>> +        if (IS_ENCRYPTED(inode) && attr->ia_size < isize &&
>>> +            (attr->ia_size % CEPH_FSCRYPT_BLOCK_SIZE)) {
>>> +            mask |= CEPH_SETATTR_SIZE;
>>> +            release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
>>> +                   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
>>> +            set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>>> +            mask |= CEPH_SETATTR_FSCRYPT_FILE;
>>> +            req->r_args.setattr.size =
>>> +                cpu_to_le64(round_up(attr->ia_size,
>>> +                             CEPH_FSCRYPT_BLOCK_SIZE));
>>> +            req->r_args.setattr.old_size =
>>> +                cpu_to_le64(round_up(isize,
>>> +                             CEPH_FSCRYPT_BLOCK_SIZE));
>>> +            req->r_fscrypt_file = attr->ia_size;
>>> +            spin_unlock(&ci->i_ceph_lock);
>>> +            err = fill_request_for_fscrypt(inode, req, attr);
>> It'd be better to just defer the call to fill_request_for_fscrypt until
>> after you've dropped the spinlock, later in the function.
>>
> Sound good and will do it.
>
>
>>> + spin_lock(&ci->i_ceph_lock);
>>> +            if (err)
>>> +                goto out;
>>> +        } else if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size 
>>> >= isize) {
>>>               if (attr->ia_size > isize) {
>>>                   i_size_write(inode, attr->ia_size);
>>>                   inode->i_blocks = calc_inode_blocks(attr->ia_size);
>>> @@ -2382,23 +2559,10 @@ int __ceph_setattr(struct inode *inode, 
>>> struct iattr *attr, struct ceph_iattr *c
>>>                  attr->ia_size != isize) {
>>>               mask |= CEPH_SETATTR_SIZE;
>>>               release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
>>> -                   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
>>> -            if (IS_ENCRYPTED(inode)) {
>>> -                set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>>> -                mask |= CEPH_SETATTR_FSCRYPT_FILE;
>>> -                req->r_args.setattr.size =
>>> -                    cpu_to_le64(round_up(attr->ia_size,
>>> -                                 CEPH_FSCRYPT_BLOCK_SIZE));
>>> -                req->r_args.setattr.old_size =
>>> -                    cpu_to_le64(round_up(isize,
>>> -                                 CEPH_FSCRYPT_BLOCK_SIZE));
>>> -                req->r_fscrypt_file = attr->ia_size;
>>> -                /* FIXME: client must zero out any partial blocks! */
>>> -            } else {
>>> -                req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
>>> -                req->r_args.setattr.old_size = cpu_to_le64(isize);
>>> -                req->r_fscrypt_file = 0;
>>> -            }
>>> +                       CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
>>> +            req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
>>> +            req->r_args.setattr.old_size = cpu_to_le64(isize);
>>> +            req->r_fscrypt_file = 0;
>>>           }
>>>       }
>>>       if (ia_valid & ATTR_MTIME) {

