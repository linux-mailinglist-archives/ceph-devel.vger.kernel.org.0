Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732CA42A668
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Oct 2021 15:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbhJLNum (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Oct 2021 09:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236678AbhJLNum (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 09:50:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC90560C40;
        Tue, 12 Oct 2021 13:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634046520;
        bh=bPX1feou8Yntt2acmepVuD6gO+H9GWbQzqB1W+dXE74=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pfuWm12JMBSAg39lpzRRV1dym2xsXRsE/ZfmXI90k18uTwjVAiBg2zS6K2k/DN61t
         WbeNabr436TYP8ccbxnOHTG3UccYqZZqujh6DWwUlchqJDVKrcav/20VrDBZifPsTD
         VcGPy334DTmFXem0lWbg95HegA6Qi8bJuX8X1SNblFSC2MQRtpdERbpIjfa7qynVVl
         br4qwD221Od5r7GV1dNIQRXLKfvGwp8KV7fKc2ZuJwjL3OcP1++SMuct42i88sUp4y
         qUMfBZ9MMYc5J75RqPjrW7hpgom5XwnpiYK2Du4RzcxDaGt2pC3FMaAgwNtubbC4nd
         4uUUgKXOT/MMw==
Message-ID: <87b2e764c6a41cc4dc796825be36fb5aefaca8cb.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: skip existing superblocks that are blocklisted
 when mounting
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>
Date:   Tue, 12 Oct 2021 09:48:38 -0400
In-Reply-To: <CAAM7YAmE8hs8sRtZgz99mb_9M2W84BBZU5u2n-BZF2SfN9dU7Q@mail.gmail.com>
References: <20210930170302.74924-1-jlayton@kernel.org>
         <CAOi1vP9YBcxMAMe1yE4v-E6gmK0GbYMKX5yODAYQOXvRd39FFg@mail.gmail.com>
         <cb422013534ef465e906b45a085e5c79dcd1b201.camel@kernel.org>
         <CAAM7YA=eFt5HVc5r=5o6A_0iuzKxNf=M3k_7Ctx0eg-DsO6CxA@mail.gmail.com>
         <24064c5d0298580ba7dbaab78a168d442246bb28.camel@kernel.org>
         <CAAM7YAmE8hs8sRtZgz99mb_9M2W84BBZU5u2n-BZF2SfN9dU7Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-10-12 at 15:09 +0800, Yan, Zheng wrote:
> 
> 
> On Mon, Oct 11, 2021 at 6:48 PM Jeff Layton <jlayton@kernel.org>
> wrote:
> > On Mon, 2021-10-11 at 11:37 +0800, Yan, Zheng wrote:
> > > 
> > > 
> > > On Tue, Oct 5, 2021 at 6:17 PM Jeff Layton <jlayton@kernel.org>
> > wrote:
> > > > On Tue, 2021-10-05 at 10:00 +0200, Ilya Dryomov wrote:
> > > > > On Thu, Sep 30, 2021 at 7:03 PM Jeff Layton
> > > > > <jlayton@kernel.org>
> > > > wrote:
> > > > > > 
> > > > > > Currently when mounting, we may end up finding an existing
> > > > superblock
> > > > > > that corresponds to a blocklisted MDS client. This means
> > > > > > that
> > > > > > the
> > > > new
> > > > > > mount ends up being unusable.
> > > > > > 
> > > > > > If we've found an existing superblock with a client that is
> > > > already
> > > > > > blocklisted, and the client is not configured to recover on
> > its
> > > > own,
> > > > > > fail the match.
> > > > > > 
> > > > > > While we're in here, also rename "other" to the more
> > > > > > conventional
> > > > "fsc".
> > > > > > 
> > > > 
> > > 
> > > 
> > > Note: we have similar issue for forced umounted superblock 
> > >  
> > 
> > True...
> > 
> > There is a small window of time between when ->umount_begin runs and
> > generic_shutdown_super happens. Between that period, you could match
> > a
> > superblock that's been forcibly umounted and is on the way to being
> > detached from the tree.
> > 
> 
> 
> I mean set fsc->mount_state to CEPH_MOUNT_SHUTDOWN, but failed to
> fully shutdown (still referenced) the superblock
>  

Good point. We could have a superblock that is still extant but that was
forcibly unmounted and detached. I'll send a v3 patch that incorporates
that case as well.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

