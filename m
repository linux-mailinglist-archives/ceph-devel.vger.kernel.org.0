Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759D0347BA8
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Mar 2021 16:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbhCXPHS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 11:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236380AbhCXPGy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 11:06:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7056C619A4;
        Wed, 24 Mar 2021 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616598413;
        bh=wak2kHwB5nWH1Gog6voUgq6mqjqQEuu5r9YxlYntmXM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k7Np5wgjHpNbKEX2PPX+rMhEz6+kstUkMZazWzcOxiMnBqj59L5WqNYjbtMUj5tgG
         RGzzXbuDCh7UlckwY+o7q7WznG71SdNU2nciE0lEm8RuchhhpWOfw0eVQG3zuEBiVk
         m5ynYUNsmGZR50eEQ1Pcx/HQe/G1JdY7DdWO9PzUyDV1qMh4IvrLUoagp2pF5Zy88c
         kLABUifj4odYR86F6LpsPi3MeqCfi2UdixJcQS4CODnY+Wjbkaeud6BMbPQ4kZ6lif
         HZ5iH2PIuKqELjNVWtvu6Vwm6XoK4m4il+/YIvrqVgMbjeSh6fWKlWDwUol+RFcfa3
         nigwROOrgLE0g==
Message-ID: <7c17357ce0b7e9671c133aa1ed3c413b6a100407.camel@kernel.org>
Subject: Re: [PATCH 0/4] ceph: add IO size metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 24 Mar 2021 11:06:52 -0400
In-Reply-To: <20210322122852.322927-1-xiubli@redhat.com>
References: <20210322122852.322927-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-03-22 at 20:28 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Currently it will show as the following:
> 
> item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)
> ----------------------------------------------------------------------------------------
> read          1           10240           10240           10240           10240
> write         1           10240           10240           10240           10240
> 
> 
> 
> Xiubo Li (4):
>   ceph: rename the metric helpers
>   ceph: update the __update_latency helper
>   ceph: avoid count the same request twice or more
>   ceph: add IO size metrics support
> 
>  fs/ceph/addr.c       |  20 +++----
>  fs/ceph/debugfs.c    |  49 +++++++++++++----
>  fs/ceph/file.c       |  47 ++++++++--------
>  fs/ceph/mds_client.c |   2 +-
>  fs/ceph/metric.c     | 126 ++++++++++++++++++++++++++++++++-----------
>  fs/ceph/metric.h     |  22 +++++---
>  6 files changed, 184 insertions(+), 82 deletions(-)
> 

I've gone ahead and merged patches 1 and 3 from this series into
ceph-client/testing. 1 was just a trivial renaming that we might as well
get out of the way, and 3 looked like a (minor) bugfix. The other two
still need a bit of work (but nothing major).

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

