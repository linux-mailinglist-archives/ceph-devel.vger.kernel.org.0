Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73329441EFC
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Nov 2021 18:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhKARKX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Nov 2021 13:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231303AbhKARKW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 13:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C5DE60E52;
        Mon,  1 Nov 2021 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635786469;
        bh=BLJ8A9OjeiQ5lUSA9+yNIs1FFQrq0+bEDoj4+wBDScc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pi7SqAf+trqlPA/NOcGUflqv2DtqNE0G4BLl01uOsUMyPP/wzYQoRey3jJzTFBm46
         C2APIZXKqZgL2gAhKl3JM3xIwYzayd0sKEDhVLVACEcgMPZ5PklhWwCWqqn9krzzmH
         dUmJPTtFtnjK+nl+/j6qOlXH+dlMaZk4jYrS23aTAHODxXhMEnbJVOzynPCF5FfG+6
         +TKO/TmDnmRzDZTPzQpab7CHHNx6mrAexqkJJjY+yYXzbnBzupUKsScX8SsjRHeOJB
         fhwGsH/NEl7rjAhMWJgaxNCw9KsOFucuMZFbUZ6jQtF4DLMpsefltj9JJ1EgYyHHnm
         NVMXU98oINtSw==
Message-ID: <b4db9a2377711857118d1fbd5835b7b8d7c9019c.camel@kernel.org>
Subject: Re: [PATCH v4 0/4] ceph: size handling for the fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 01 Nov 2021 13:07:47 -0400
In-Reply-To: <5c5d98f06c0a70271b324d9f144f44f8dddd91e5.camel@kernel.org>
References: <20211101020447.75872-1-xiubli@redhat.com>
         <5c5d98f06c0a70271b324d9f144f44f8dddd91e5.camel@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-11-01 at 06:27 -0400, Jeff Layton wrote:
> On Mon, 2021-11-01 at 10:04 +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > This patch series is based on the "fscrypt_size_handling" branch in
> > https://github.com/lxbsz/linux.git, which is based Jeff's
> > "ceph-fscrypt-content-experimental" branch in
> > https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git
> > and added two upstream commits, which should be merged already.
> > 
> > These two upstream commits should be removed after Jeff rebase
> > his "ceph-fscrypt-content-experimental" branch to upstream code.
> > 
> 
> I don't think I was clear last time. I'd like for you to post the
> _entire_ stack of patches that is based on top of
> ceph-client/wip-fscrypt-fnames. wip-fscrypt-fnames is pretty stable at
> this point, so I think it's a reasonable place for you to base your
> work. That way you're not beginning with a revert.
> 
> Again, feel free to cherry-pick any of the patches in any of my other
> branches for your series, but I'd like to see a complete series of
> patches.
> 
> 

To be even more clear:

The main reason this patchset is not helpful is that the
ceph-fscrypt-content-experimental branch in my tree has bitrotted in the
face of other changes that have gone into the testing branch since it
was cut. Also, that branch had several patches that added in actual
encryption of the content, which we don't want to do at this point.

For the work you're doing, what I'd like to see is a patchset based on
top of the ceph-client/wip-fscrypt-fnames branch. That patchset should
make it so what when encryption is enabled, the size handling for the
inode is changed to use the new scheme we've added, but don't do any
actual content encryption yet. Feel free to pick any of the patches in
my trees that you need to do this, but it needs to be the whole series.

What we need to be able to do in this phase is validate that the size
handling is correct in both the encrypted and non-encrypted cases, but
without encrypting the data. Once that piece is working, then we should
be able to add in content encryption.


> 
> > ====
> > 
> > This approach is based on the discussion from V1 and V2, which will
> > pass the encrypted last block contents to MDS along with the truncate
> > request.
> > 
> > This will send the encrypted last block contents to MDS along with
> > the truncate request when truncating to a smaller size and at the
> > same time new size does not align to BLOCK SIZE.
> > 
> > The MDS side patch is raised in PR
> > https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
> > previous great work in PR https://github.com/ceph/ceph/pull/41284.
> > 
> > The MDS will use the filer.write_trunc(), which could update and
> > truncate the file in one shot, instead of filer.truncate().
> > 
> > This just assume kclient won't support the inline data feature, which
> > will be remove soon, more detail please see:
> > https://tracker.ceph.com/issues/52916
> > 
> > Changed in V4:
> > - Retry the truncate request by 20 times before fail it with -EAGAIN.
> > - Remove the "fill_last_block" label and move the code to else branch.
> > - Remove the #3 patch, which has already been sent out separately, in
> >   V3 series.
> > - Improve some comments in the code.
> > 
> > 
> > Changed in V3:
> > - Fix possibly corrupting the file just before the MDS acquires the
> >   xlock for FILE lock, another client has updated it.
> > - Flush the pagecache buffer before reading the last block for the
> >   when filling the truncate request.
> > - Some other minore fixes.
> > 
> > Xiubo Li (4):
> >   Revert "ceph: make client zero partial trailing block on truncate"
> >   ceph: add __ceph_get_caps helper support
> >   ceph: add __ceph_sync_read helper support
> >   ceph: add truncate size handling support for fscrypt
> > 
> >  fs/ceph/caps.c              |  21 ++--
> >  fs/ceph/file.c              |  44 +++++---
> >  fs/ceph/inode.c             | 203 ++++++++++++++++++++++++++++++------
> >  fs/ceph/super.h             |   6 +-
> >  include/linux/ceph/crypto.h |  28 +++++
> >  5 files changed, 251 insertions(+), 51 deletions(-)
> >  create mode 100644 include/linux/ceph/crypto.h
> > 
> 

-- 
Jeff Layton <jlayton@kernel.org>

