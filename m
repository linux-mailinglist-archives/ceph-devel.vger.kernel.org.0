Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265CF2CF607
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Dec 2020 22:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgLDVOL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Dec 2020 16:14:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgLDVOL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 16:14:11 -0500
Message-ID: <0920eb110e59b6e3090cde8bd1845ee083d7880a.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607116410;
        bh=vUECHO+Bdt9z+lFD/ClAAxKgebkXbq7b1VL0AYd8LW0=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=Tza2lCAWaXzK8iw55Wu3Gd5F1MEU0MiEfoA2LmvDvizqh+VBFpcjt6JwaQoLL87ES
         9JtRq6hL2Uao94FCXmRh7yduQSi7JtV83HPf5Hc6ADJIzcX5xUmdPnX+8nKAL1vuf/
         CriEBzmRE4peOXTqWrvM+o4rVhMhFTLE8pGkRkfLIIM+C+vBqkxn3uuC8X4kKvYjW2
         s9jY0opWbuuys3H2vUpLydxuS8LPj7/x7OykHE0iPYRJlsqJOtD+MSrfBmUvUU4bk+
         1q5qC4PGnCXPTqbdGnURNJqwRVj1JdKVouqBdZ6HlTIpiiDRUlYsj1BGYBNUhz/GsK
         PnmBM8F1kIJ+A==
Subject: Re: Investigate busy ceph-msgr worker thread
From:   Jeff Layton <jlayton@kernel.org>
To:     Stefan Kooman <stefan@bit.nl>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Fri, 04 Dec 2020 16:13:29 -0500
In-Reply-To: <945af793-1425-181a-c334-99e6602bc899@bit.nl>
References: <9afdb763-4cf6-3477-bd32-762840c0c0a5@bit.nl>
         <ac5253d71ea50c8f5b4e50a07a1a0180abd58562.camel@kernel.org>
         <945af793-1425-181a-c334-99e6602bc899@bit.nl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-12-04 at 20:49 +0100, Stefan Kooman wrote:
> On 12/3/20 5:46 PM, Jeff Layton wrote:
> > On Thu, 2020-12-03 at 12:01 +0100, Stefan Kooman wrote:
> > > Hi,
> > > 
> > > We have a cephfs linux kernel (5.4.0-53-generic) workload (rsync) that
> > > seems to be limited by a single ceph-msgr thread (doing close to 100%
> > > cpu). We would like to investigate what this thread is so busy with.
> > > What would be the easiest way to do this? On a related note: what would
> > > be the best way to scale cephfs client performance for a single process
> > > (if at all possible)?
> > > 
> > > Thanks for any pointers.
> > > 
> > 
> > Usually kernel profiling (a'la perf) is the way to go about this. You
> > may want to consider trying more recent kernels and see if they fare any
> > better. With a new enough MDS and kernel, you can try enabling async
> > creates as well, and see whether that helps performance any.
> 
> The thread is mostly busy with "build_snap_context":
> 
> 
> +   94.39%    94.23%  kworker/4:1-cep  [kernel.kallsyms]  [k] 
> build_snap_context
> 
> Do I understand correctly if this code is checking for any potential 
> snapshots? As grepping through linux cephfs code gives a hit on snap.c
> 
> Our cephfs filesystem has been created in Luminous, and upgraded through 
> Mimic to Nautilus. We have never enabled snapshot support (ceph fs set 
> cephfs allow_new_snaps true). But the filesystem does seem to support it 
> (.snap dirs present). The data rsync is processing does contain a lot of 
> directories. It might explain the amount of time spent in this code path.
> 
> Would this be a plausible explanation?
> 
> Thanks,
> 
> Stefan

Yes, that sounds plausible. You probably want to stop rsync from
recursing down into .snap/ directories altogether if you have it doing
that.
-- 
Jeff Layton <jlayton@kernel.org>

