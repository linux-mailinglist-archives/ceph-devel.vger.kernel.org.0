Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26A324A03F
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgHSNlp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 09:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbgHSNlo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 09:41:44 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF1020639;
        Wed, 19 Aug 2020 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597844504;
        bh=Vd0m5wT9GlpjTuN34y6//T1FTZGfsOxcbiAsUGBpTzU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kE6hGvt3kb7wSTvTJHVNjGgo+rkGixR9jI2jcB1m3mcAQBkYA+FEqMfCNI00XhWvt
         xgR8hwnE74z6aPDgMaFjgpyPxtGwV/Ot647nXlznFwafDE4iqhDaMEaTptjwZ5IWL9
         q1qHdF8OkzAcn2myo8NIUnvtuuTr9uiEkPHMfRA0=
Message-ID: <ec2fe8a11a0c47774fa52a1beb38ebe5fe12a68b.camel@kernel.org>
Subject: Re: [PATCH] ceph: add dirs/files' opened/opening metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 19 Aug 2020 09:41:42 -0400
In-Reply-To: <d2bb621f-5bfa-c936-b589-e13ae13cc6d9@redhat.com>
References: <20200818115317.104579-1-xiubli@redhat.com>
         <7b1e716346aee082cd1ff426faf6b9bff0276ae0.camel@kernel.org>
         <CA+2bHPZoHhaEBKBKGiR6=Ui7NYnLyT-fMUYHvCcXtT2-oWXRdg@mail.gmail.com>
         <d2bb621f-5bfa-c936-b589-e13ae13cc6d9@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-08-19 at 10:01 +0800, Xiubo Li wrote:
> On 2020/8/19 4:10, Patrick Donnelly wrote:
> > On Tue, Aug 18, 2020 at 1:05 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > Bear in mind that if the same file has been opened several times, then
> > > you'll get an increment for each.
> > Having an open file count (even for the same inode) and a count of
> > inodes opened sounds useful to me. The latter would require some kind
> > of refcounting for each inode? Maybe that's too expensive though.
> 
> For the second, yes, we need one percpu refcount, which can be add in 
> ceph_get_fmode() when increasing any entry of the 
> ci->i_nr_by_mode[fmode] for the first time, to decrease it in 
> ceph_put_fmode() when the ci->i_nr_by_mode[fmode] is empty. IMO, it 
> should be okay and won't cost too much.
> 
> Thanks
> 
> BRs
> 

Sure.

To be clear, I'm not _really_ disputing the usefulness of these stats,
but I think if we're going to measure stuff like this, the changelog
needs to justify it in some way.

We may find in 2-3 years that some of these are not as useful as we
first thought, and if we don't have any of the original justification in
the changelog for it, it's harder to determine whether removing them is
ok.

> > > Would it potentially be more useful to report the number of inodes that
> > > have open file descriptions associated with them? It's hard for me to
> > > know as I'm not clear on the intended use-case for this.
> > Use-case is more information available via `fs top`.
> > 

-- 
Jeff Layton <jlayton@kernel.org>

