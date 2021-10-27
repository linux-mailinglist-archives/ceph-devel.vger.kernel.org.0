Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A8743C96A
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Oct 2021 14:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239999AbhJ0MUX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 08:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230420AbhJ0MUX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 08:20:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ABD860F5A;
        Wed, 27 Oct 2021 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635337077;
        bh=RbjTkFLDAIrdc5JuiJcBvAG4QHFa3XhBGDD+dzY/X/M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UYIBGQYyRHmVmm8spSTUp5YHbTCR76vnDtFt1ps/DGNZxdohkq+2hjFX+80ie/rVu
         dR34BEgu7jgdbhXexYTJhNikXFmaM2wEm8I+4vNDaB56nu+b/GqD60UnQU6ecnALX7
         DA4W9XGs8tkyViRO/s3XKEb9uwGzD2F/e/cqHeVU3R2RYFPc1tDOwhegamcmj8OhYt
         RntXVa+lLgvELSw/LT3gx9weuI0AwPzncZuoqCGEoNp7N1Hd0GaBrkNle0f1NOcbUH
         YLSvP0wOsqavlrJnNWYC/bhlpyrl5ZDB3J4CfXKHFxsdhvFfDxqxgnSr+cZB/V3SEO
         pSvLakVR2TAKA==
Message-ID: <cb4ddb7a862dbb0b5f44c4c4a131adfc8c3f008c.camel@kernel.org>
Subject: Re: [PATCH v2 4/4] ceph: add truncate size handling support for
 fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Date:   Wed, 27 Oct 2021 08:17:55 -0400
In-Reply-To: <3a9971c2-916a-1d90-1f77-4bb5bd3befb2@redhat.com>
References: <20211020132813.543695-1-xiubli@redhat.com>
         <20211020132813.543695-5-xiubli@redhat.com>
         <d3ffc19d0b3f20a56d49428a486acfd9d6b22001.camel@kernel.org>
         <3a9971c2-916a-1d90-1f77-4bb5bd3befb2@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-10-27 at 13:12 +0800, Xiubo Li wrote:
> On 10/26/21 4:01 AM, Jeff Layton wrote:
> > On Wed, 2021-10-20 at 21:28 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > This will transfer the encrypted last block contents to the MDS
> > > along with the truncate request only when new size is smaller and
> > > not aligned to the fscrypt BLOCK size.
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/caps.c  |   9 +--
> > >   fs/ceph/inode.c | 210 ++++++++++++++++++++++++++++++++++++++++++------
> > >   2 files changed, 190 insertions(+), 29 deletions(-)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index 4e2a588465c5..1a36f0870d89 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> ...
> > > +fill_last_block:
> > > +	pagelist = ceph_pagelist_alloc(GFP_KERNEL);
> > > +	if (!pagelist)
> > > +		return -ENOMEM;
> > > +
> > > +	/* Insert the header first */
> > > +	header.ver = 1;
> > > +	header.compat = 1;
> > > +	/* sizeof(file_offset) + sizeof(block_size) + blen */
> > > +	header.data_len = cpu_to_le32(8 + 8 + CEPH_FSCRYPT_BLOCK_SIZE);
> > > +	header.file_offset = cpu_to_le64(orig_pos);
> > > +	if (fill_header_only) {
> > > +		header.file_offset = cpu_to_le64(0);
> > > +		header.block_size = cpu_to_le64(0);
> > > +	} else {
> > > +		header.file_offset = cpu_to_le64(orig_pos);
> > > +		header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
> > > +	}
> > > +	ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
> > > +	if (ret)
> > > +		goto out;
> > > 
> > > 
> > Note that you're doing a read/modify/write cycle, and you must ensure
> > that the object remains consistent between the read and write or you may
> > end up with data corruption. This means that you probably need to
> > transmit an object version as part of the write. See this patch in the
> > stack:
> > 
> >      libceph: add CEPH_OSD_OP_ASSERT_VER support
> > 
> > That op tells the OSD to stop processing the request if the version is
> > wrong.
> > 
> > You'll want to grab the "ver" from the __ceph_sync_read call, and then
> > send that along with the updated last block. Then, when the MDS is
> > truncating, it can use a CEPH_OSD_OP_ASSERT_VER op with that version to
> > ensure that the object hasn't changed when doing it. If the assertion
> > trips, then the MDS should send back EAGAIN or something similar to the
> > client to tell it to retry.
> > 
> > It's also possible (though I've never used it) to make an OSD request
> > assert that the contents of an extent haven't changed, so you could
> > instead send along the old contents along with the new ones, etc.
> > 
> > That may end up being more efficient if the object is getting hammered
> > with I/O in other fscrypt blocks within the same object. It may be worth
> > exploring that avenue as well.
> 
> Hi Jeff,
> 
> One questions about this:
> 
> Should we consider that the FSCRYPT BLOCK will cross two different Rados 
> objects ? As default the Rados object size is 4MB.
> 
> In case the FSCRYPT BLOCK size is 4K, when the object size is 3K or 5K ?
> 
> Or the object size should always be multiple of FSCRYPT BLOCK size ?
> 

The danger here is that it's very hard to ensure atomicity in RADOS
across two different objects. If your crypto blocks can span objects,
then you can end up with torn writes, and a torn write on a crypto block
turns it into garbage.

So, I think we want to forbid:

1/ custom file layouts on encrypted files, to ensure that we don't end
up with weird object sizes. Luis' patch from August does this, but I
think we might want the MDS to also vet this.

2/ block sizes larger than the object size

3/ non-power-of-two crypto block sizes (so no 3k or 5k blocks, but you
could do 1k, 2k, 4k, 8k, etc...)

...with that we should be able to ensure that they never span objects.
Eventually we may be able to relax some of these constraints, but I
don't think most users will have a problem with these constraints.

-- 
Jeff Layton <jlayton@kernel.org>

