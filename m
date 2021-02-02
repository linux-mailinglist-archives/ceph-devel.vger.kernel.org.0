Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB83030BEA5
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Feb 2021 13:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhBBMsT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 07:48:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231733AbhBBMpq (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 07:45:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EED7A64F45;
        Tue,  2 Feb 2021 12:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612269905;
        bh=6HA5I9g54CWrnRgluc9jlCXT97+bsnUCbtvbzOw3A1s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iKlS6sT8hoWT/xzA4jWsdm6Q2yM/2gkw92EXQ8XN7o21TV8e9xRJCPBY5TFENSpIV
         7wUxffoUHCECK6QtPmCtYJVNqsGCNaRgKmE72Zl0fKXhC1rEImwQlVYG8x1z+6q21i
         H5+LW9EW0i1Luudlf5B68ptEsTR2vQX5eV/6+zb4J6z49C051Fj16P1821LGIgVKt+
         MdcyzK7YAmBfvTGwRLV1kW2rWoD9Aoifn3Bu6k5LIpgBHM+sC938en4ww//asb4Fpx
         QTvDI5kRSv42O65NBKUQZb/C+pXy9g2LhCtm7tInaTenOq7IzgTtkp7W0djjxuT+zT
         dHj+MfsC9Erog==
Message-ID: <af100a9c49cca8c9da2b9656c017c38dca2a02f9.camel@kernel.org>
Subject: Re: [PATCH] ceph: Replace DEFINE_SIMPLE_ATTRIBUTE with
 DEFINE_DEBUGFS_ATTRIBUTE
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Tue, 02 Feb 2021 07:45:03 -0500
In-Reply-To: <CAOi1vP_ifWsyOjXo2NaDQnAT9Gn22442KuUXp1LjDCWfpH5yuQ@mail.gmail.com>
References: <1612165930-110076-1-git-send-email-jiapeng.chong@linux.alibaba.com>
         <CAOi1vP_ifWsyOjXo2NaDQnAT9Gn22442KuUXp1LjDCWfpH5yuQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-02-02 at 13:07 +0100, Ilya Dryomov wrote:
> On Mon, Feb 1, 2021 at 8:52 AM Jiapeng Chong
> <jiapeng.chong@linux.alibaba.com> wrote:
> > 
> > Fix the following coccicheck warning:
> > 
> > ./fs/ceph/debugfs.c:347:0-23: WARNING: congestion_kb_fops should be
> > defined with DEFINE_DEBUGFS_ATTRIBUTE.
> > 
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > ---
> >  fs/ceph/debugfs.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > index 66989c8..617327e 100644
> > --- a/fs/ceph/debugfs.c
> > +++ b/fs/ceph/debugfs.c
> > @@ -344,8 +344,8 @@ static int congestion_kb_get(void *data, u64 *val)
> >         return 0;
> >  }
> > 
> > -DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
> > -                       congestion_kb_set, "%llu\n");
> > +DEFINE_DEBUGFS_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
> > +                         congestion_kb_set, "%llu\n");
> > 
> > 
> >  void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
> 
> Hi Jiapeng,
> 
> What is the benefit of this conversion?
> 
> From a quick look, with DEFINE_DEBUGFS_ATTRIBUTE writeback_congestion_kb
> file would no longer be seekable.  It may not matter much, but something
> that should have been mentioned.
> 
> Futher, debugfs_create_file() creates a full proxy for fops, protecting
> against removal races.  DEFINE_DEBUGFS_ATTRIBUTE adds its own protection
> but just for ->read() and ->write().  I don't think we need both.
> 


The coccinelle script clarifies some of this. See the commit log here:

    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5103068eaca290f890a30aae70085fac44cecaf6

That said, it also mentions that the file should be converted to use
debugfs_create_file_unsafe now as well, and that wasn't done in this
patch. Jiapeng, was that intentional? If so, why?

-- 
Jeff Layton <jlayton@kernel.org>

