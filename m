Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F79082FC6
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 12:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732474AbfHFKfT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 06:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfHFKfT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 06:35:19 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EBA120B1F;
        Tue,  6 Aug 2019 10:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565087718;
        bh=5uEJGEnf0POX97W4uku8pfQigCiKdHxRxIMHnbh45WU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Z1msf/pr6IZh1pVtA2cGQQaiScTpHUCBZ4SBohK7aAeR3/n5VhfBuQbxvj7nbZEYh
         mkXCUl2pN+lnVa3MbzyPceh27jr0cr9tl7xh9n/OYpWjTVp7GAE4H5wTHB7mEc71Um
         u1UwFYH9eTvqqewHX+bpJos4ppinAe8CzTcPzbWk=
Message-ID: <a0db7ebed3aef86f4e6d0cb4f47d5f3f93a9c04a.camel@kernel.org>
Subject: Re: [PATCH] ceph: add buffered/direct exclusionary locking for
 reads and writes
From:   Jeff Layton <jlayton@kernel.org>
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, ukernel@gmail.com
Date:   Tue, 06 Aug 2019 06:35:16 -0400
In-Reply-To: <alpine.DEB.2.11.1908060326400.25659@piezo.novalocal>
References: <20190805200501.17905-1-jlayton@kernel.org>
         <alpine.DEB.2.11.1908060326400.25659@piezo.novalocal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-08-06 at 03:27 +0000, Sage Weil wrote:
> On Mon, 5 Aug 2019, Jeff Layton wrote:
> > xfstest generic/451 intermittently fails. The test does O_DIRECT writes
> > to a file, and then reads back the result using buffered I/O, while
> > running a separate set of tasks that are also doing buffered reads.
> > 
> > The client will invalidate the cache prior to a direct write, but it's
> > easy for one of the other readers' replies to race in and reinstantiate
> > the invalidated range with stale data.
> 
> Maybe a silly question, but: what if the write path did the invalidation 
> after the write instead of before?  Then any racing read will see the new 
> data on disk.
> 

I tried that originally. It reduces the race window somewhat, but it's
still present since a reply to a concurrent read can get in just after
the invalidation occurs. You really do have to serialize them to fix
this, AFAICT.
-- 
Jeff Layton <jlayton@kernel.org>

