Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE133392AC
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Mar 2021 17:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhCLQFg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Mar 2021 11:05:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230388AbhCLQFT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 11:05:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7054464FFE;
        Fri, 12 Mar 2021 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615565118;
        bh=CmDpd97lKZSN0mhvwEYIyeKWw9LwbjmSI5MecNOGHac=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Bvdyn/TNpsH3pEoNi+Hpvkc+ILJadhGJ5yq81p9x8YDlG7tp+AXNNvV0sSZ9B0Ctq
         Y9qSC17h80OjLV1nWWvjamnbmOX764MssKKoaP9COYYaSSUwMX8qQ5sTNl3hgeVNMi
         yvjviTOJp+HHWvyD/MYsfBttJwr80FDmbsutwFBa0ikKEMFRBoeoCOqlpEtLL1emfK
         SAJyl8YIrQlt4pHqle9Kwy7p1PRDC/4woXlbroKNoZk+x5/qKhjXqKPpkjFbCfpgee
         wNKsn3iFArUQFG6krfMUIjxpJoJYiTHjZqNLF8pZ/bEw1WDuJmFd5/yjAPZWX3mzXC
         eL6B3DfbJp5EA==
Message-ID: <99166b01f66d8fa45dd596e9d5bc0a7175bf6a4b.camel@kernel.org>
Subject: Re: ceph-client/testing branch rebased
From:   Jeff Layton <jlayton@kernel.org>
To:     David Howells <dhowells@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Fri, 12 Mar 2021 11:05:17 -0500
In-Reply-To: <201976.1615326505@warthog.procyon.org.uk>
References: <CAOi1vP9g+wFpw6ws5ap9T4nbPxLK0J-KegeoH4HZXQhC=UL2-g@mail.gmail.com>
         <ac3703b3b382cc6e947904238e3dc4c671eb7847.camel@kernel.org>
         <201976.1615326505@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-03-09 at 21:48 +0000, David Howells wrote:
> Ilya Dryomov <idryomov@gmail.com> wrote:
> 
> > Could you please create a named branch that doesn't include AFS bits
> > (e.g. netfs-next)?  It is going to be needed once we get closer to
> > a merge window and netfs helper library is finalized.  I won't be able
> > to pull a seemingly random SHA (of the commit preceding the first AFS
> > commit) into ceph-client/master.
> 
> I will do.  Currently I'm slightly stalled waiting on Willy.  He wants me to
> make some changes and I'm hoping he'll tell me what they should be at some
> point.
> 


I agree with Ilya that we shouldn't be keeping AFS changes in the ceph
tree. Until you and Willy sort it out, would it be possible to instead
keep up two branches?

1/ a netfs lib one (probably at 5ed6545841ed in your tree as of today)

2/ and one based on top of 1 that has the AFS patches (currently the
fscache-netfs-lib branch).

I can just rebase our tree onto 5ed6545841ed for now, but going forward
it'd be better if we were based on a branch or tag in your tree.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

