Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B8A72D99B
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 08:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbjFMGBe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 02:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbjFMGBc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 02:01:32 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E151B3
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 23:01:31 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A0E6E68CFE; Tue, 13 Jun 2023 08:01:23 +0200 (CEST)
Date:   Tue, 13 Jun 2023 08:01:21 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, idryomov@gmail.com,
        jlayton@kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: set FMODE_CAN_ODIRECT instead of a dummy
 direct_IO method
Message-ID: <20230613060121.GA14924@lst.de>
References: <20230612053537.585525-1-hch@lst.de> <366e91fa-53b9-008d-8aea-7498d452b234@redhat.com> <20230612053537.585525-1-hch@lst.de> <099cc669-11b9-e5f1-e370-599679e87806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <366e91fa-53b9-008d-8aea-7498d452b234@redhat.com> <099cc669-11b9-e5f1-e370-599679e87806@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 13, 2023 at 08:57:42AM +0800, Xiubo Li wrote:
>> +	if (S_ISREG(inode->i_mode))
>> +		file->f_mode |= FMODE_CAN_ODIRECT;
>>   
>
> Shouldn't we do the same in 'ceph_atomic_open()' too ?

Yes, probably.  Or I really need to press ahead and move the flag
to file operations..

>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -368,6 +368,8 @@ int ceph_open(struct inode *inode, struct file *file)
>>   	flags = file->f_flags & ~(O_CREAT|O_EXCL);
>>   	if (S_ISDIR(inode->i_mode))
>>   		flags = O_DIRECTORY;  /* mds likes to know */
>> +	if (S_ISREG(inode->i_mode))
>
> BTW, the commit a2ad63daa88b ("VFS: add FMODE_CAN_ODIRECT file flag") 
> doesn't check the S_ISREG, and I couldn't see this commit and NFS confine 
> it to regular files, is that okay ?

It doesn't have to.  ->direct_IO was previously set only for regular
files (and block devices in the block code).  So it makes sense to do
the same for the flag.
