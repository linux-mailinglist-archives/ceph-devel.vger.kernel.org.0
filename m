Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0FB1899C7
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 11:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbgCRKn1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 06:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbgCRKn0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 06:43:26 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80A042076D;
        Wed, 18 Mar 2020 10:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584528206;
        bh=vdjjv6BWH8NyjoBuQ1XZju1OxzOoRRvaGD0mre+kEVk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TK6Uoh8kE5wtKOOwYEBIiTrZBpCLr/8L7D07IBeRUUjLXM2Aq8q1WNBl3u+vqAnxQ
         WiFliThpX/eMYYynU61Hl5PfS/K+tgqoBrcb7LfYGP1K5p6jfy+yxg/Hl3fhCHlQRW
         X8wBfKpdxjSL4LQVhMRr0mxDG/bB2u7q5JuS+7qU=
Message-ID: <bc219cca2ad17b85b02b67b515e36d608e3229a1.camel@kernel.org>
Subject: Re: [PATCH v4 0/4] ceph: add min/max/stdev latency support
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 18 Mar 2020 06:43:24 -0400
In-Reply-To: <c980a7e9-95fd-97db-e851-7f83c35d6d96@redhat.com>
References: <1584510355-6936-1-git-send-email-xiubli@redhat.com>
         <CAOi1vP_gj6TuJHjKdyWCf47ukKgszJE30-BnrvxjD7cu5VnV0Q@mail.gmail.com>
         <c980a7e9-95fd-97db-e851-7f83c35d6d96@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-03-18 at 18:36 +0800, Xiubo Li wrote:
> On 2020/3/18 17:11, Ilya Dryomov wrote:
> > On Wed, Mar 18, 2020 at 6:46 AM <xiubli@redhat.com> wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Changed in V4:
> > > - fix the 32-bit arches div errors by using DIV64_U64_ROUND_CLOSEST instead. [1/4]
> > > - rebase and combine the stdev patch series [3/4][4/4]
> > > - remove the sum latency showing, which makes no sense for debugging, if it
> > >    is really needed in some case then just do (avg * total) in userland. [4/4]
> > > - switch {read/write/metadata}_latency_sum to atomic type since it will be
> > >    readed very time when updating the latencies to calculate the stdev. [4/4]
> > > 
> > > Changed in V2:
> > > - switch spin lock to cmpxchg [1/4]
> > > 
> > > Changed in V3:
> > > - add the __update_min/max_latency helpers [1/4]
> > > 
> > > 
> > > 
> > > # cat /sys/kernel/debug/ceph/0f923fe5-00e6-4866-bf01-2027cb75e94b.client4150/metrics
> > > item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
> > > -----------------------------------------------------------------------------------
> > > read          2312        9000            1000            100000          607.4
> > > write         21777       925000          2000            44551000        29700.3
> > > metadata      6           4179000         1000            21414000        19590.8
> > > 
> > > item          total           miss            hit
> > > -------------------------------------------------
> > > d_lease       2               0               11
> > > caps          2               14              398418
> > > 
> > > 
> > > 
> > > Xiubo Li (4):
> > >    ceph: switch to DIV64_U64_ROUND_CLOSEST to support 32-bit arches
> > >    ceph: add min/max latency support for read/write/metadata metrics
> > >    ceph: move the metric helpers into one separate file
> > >    ceph: add standard deviation support for read/write/metadata perf
> > >      metric
> > > 
> > >   fs/ceph/Makefile     |   2 +-
> > >   fs/ceph/debugfs.c    |  89 ++++++++++++++++++------
> > >   fs/ceph/mds_client.c |  83 +---------------------
> > >   fs/ceph/metric.c     | 190 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >   fs/ceph/metric.h     |  79 +++++++++++----------
> > >   5 files changed, 297 insertions(+), 146 deletions(-)
> > >   create mode 100644 fs/ceph/metric.c
> > Hi Xiubo,
> > 
> > I think these additions need to be merged with your previous series,
> > so that the history is clean.  Ideally the whole thing would start with
> > a single patch adding all of the metrics infrastructure to metric.[ch],
> > followed by patches introducing new metrics and ceph_update_*() calls.
> > 
> > Related metrics and ceph_update_*() calls should be added together.
> > No point in splitting read and write OSD latency in two patches as they
> > touch the same functions in addr.c and file.c.
> 
> Hi Ilya,
> 
> Yeah, it makes sense and I will merge all the related patch series about 
> the metric and post it again.
> 

Sounds good. I've gone ahead and dropped all of the metrics patches from
the "testing" branch for now. Please resend the whole series and I'll
re-merge them.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

