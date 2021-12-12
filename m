Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136BF471CFC
	for <lists+ceph-devel@lfdr.de>; Sun, 12 Dec 2021 21:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhLLUie (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 12 Dec 2021 15:38:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37686 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhLLUid (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 12 Dec 2021 15:38:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C6DFB80D78;
        Sun, 12 Dec 2021 20:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3954C341CB;
        Sun, 12 Dec 2021 20:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639341511;
        bh=d4dQzuYijMRaQa0+iadVCHp++mlzc4QSc314eWIxrhE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WQMdO2YxpevMuXiuM/qq8Nm/js8SkLODoYljyCw0n8Bw3R32zaGWEVHo9AAc9Yf9A
         6ih5fXweO5WTS9IE2CWJfwfFH10pdrnIuxyEdIhnf/21tUL45bdXfmkkuKa1P8P5dd
         YiUytcPH+cbi6axrOB16uAgB0jPWqTMpwUwxPpS42xy9qORv3cA/GOpvyQzqFkicqq
         R4VBMtgiSgrY1AU6PC4CpJHwcbV5xazpz/vk9gzXEMV19KAfk9X9WA47jzACnfqBAI
         PmpY/y8fQIDhbZOzoFtpGi5Zm9FMwWM+2u9LSbEpl9o19foME6RgqpFFjUGDJYBnkx
         dCNpcO0Q8OxHg==
Message-ID: <cd3ce02be39e073f4a6d0846d2da1ee312e118e0.camel@kernel.org>
Subject: Re: [PATCH 05/36] fscrypt: uninline and export fscrypt_require_key
From:   Jeff Layton <jlayton@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date:   Sun, 12 Dec 2021 15:38:29 -0500
In-Reply-To: <YbZT6kXlrVO5doMT@sol.localdomain>
References: <20211209153647.58953-1-jlayton@kernel.org>
         <20211209153647.58953-6-jlayton@kernel.org>
         <YbOuhUalMBuTGAGI@sol.localdomain>
         <8c90912c5fd01a713688b1d2523ffe47df747513.camel@kernel.org>
         <YbZT6kXlrVO5doMT@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2021-12-12 at 11:56 -0800, Eric Biggers wrote:
> On Fri, Dec 10, 2021 at 03:40:20PM -0500, Jeff Layton wrote:
> > On Fri, 2021-12-10 at 11:46 -0800, Eric Biggers wrote:
> > > On Thu, Dec 09, 2021 at 10:36:16AM -0500, Jeff Layton wrote:
> > > > ceph_atomic_open needs to be able to call this.
> > > > 
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/crypto/fscrypt_private.h | 26 --------------------------
> > > >  fs/crypto/keysetup.c        | 27 +++++++++++++++++++++++++++
> > > >  include/linux/fscrypt.h     |  5 +++++
> > > >  3 files changed, 32 insertions(+), 26 deletions(-)
> > > 
> > > What is the use case for this, more precisely?  I've been trying to keep
> > > filesystems using helper functions like fscrypt_prepare_*() and
> > > fscrypt_file_open() rather than setting up encryption keys directly, which is a
> > > bit too low-level to be doing outside of fs/crypto/.
> > > 
> > > Perhaps fscrypt_file_open() is what you're looking for here?
> > 
> > That doesn't really help because we don't have the inode for the file
> > yet at the point where we need the key.
> > 
> > atomic_open basically does a lookup+open. You give it a directory inode
> > and a dentry, and it issues an open request by filename. If it gets back
> > ENOENT then we know that the thing is a negative dentry.
> > 
> > In the lookup path, I used __fscrypt_prepare_readdir. This situation is
> > a bit similar so I might be able to use that instead. OTOH, that doesn't
> > fail when you don't have the key, and if you don't, there's not a lot of
> > point in going any further here.
> 
> So you're requiring the key on a directory to do a lookup in that directory?
> Normally that's not required, as files can be looked up by no-key name.  Why is
> the atomic_open case different? 
> 
> The file inode's key is needed to open it, of
> course, but the directory inode's key shouldn't be needed.  In practice you'll
> tend to have the key for both or neither inode, but that's not guaranteed.
> 

We're issuing an open request to the server without looking up the inode
first. In order to do that open request, we need to encode a filename
into the request, and to do that we need the encryption key.
-- 
Jeff Layton <jlayton@kernel.org>
