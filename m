Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D871248FA8
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Aug 2020 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHRUkz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Aug 2020 16:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgHRUky (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 Aug 2020 16:40:54 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B632063A;
        Tue, 18 Aug 2020 20:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597783254;
        bh=zAH41hFBjiSMGVAQpjlGTarZM5EJs0jmXNUtCJ3gLiE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nBkBvkmGsr+z7g+TyXMK1AfFmy1ReJXKs0tmZsV/mv0EKJntcGBbohVTX5Zqe6lRB
         JWHnW8MScYgKg5bLUp0MIlOVEDHdgESx7E1vslw2itbQ907r7JDzBCYbH8Ph0uFGCp
         qCghbBab+nRVZ/oXQ8YbKAXggAinosCwg+gT4FHA=
Message-ID: <efd26c69851fbe37a1cd3b07ba18092e4631b4b3.camel@kernel.org>
Subject: Re: [PATCH] ceph: add dirs/files' opened/opening metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 18 Aug 2020 16:40:52 -0400
In-Reply-To: <CA+2bHPZoHhaEBKBKGiR6=Ui7NYnLyT-fMUYHvCcXtT2-oWXRdg@mail.gmail.com>
References: <20200818115317.104579-1-xiubli@redhat.com>
         <7b1e716346aee082cd1ff426faf6b9bff0276ae0.camel@kernel.org>
         <CA+2bHPZoHhaEBKBKGiR6=Ui7NYnLyT-fMUYHvCcXtT2-oWXRdg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-08-18 at 13:10 -0700, Patrick Donnelly wrote:
> On Tue, Aug 18, 2020 at 1:05 PM Jeff Layton <jlayton@kernel.org> wrote:
> > Bear in mind that if the same file has been opened several times, then
> > you'll get an increment for each.
> 
> Having an open file count (even for the same inode) and a count of
> inodes opened sounds useful to me. The latter would require some kind
> of refcounting for each inode? Maybe that's too expensive though.
> 

It might be useful. It really depends on what you want to do with this
info.

The MDS is generally interested in inodes and their caps, and it usually
knows how many opens we have, except in the case where we have
sufficient caps and can make the attempt w/o having to talk to it. Is
knowing an official number of actual open file descriptions helpful?
Why?

> > Would it potentially be more useful to report the number of inodes that
> > have open file descriptions associated with them? It's hard for me to
> > know as I'm not clear on the intended use-case for this.
> 
> Use-case is more information available via `fs top`.
> 

Which is, again, vague. What do you expect to do with this info? Why is
it useful? Articulating that up front will help us determine whether
we're measuring what we need to measure.
-- 
Jeff Layton <jlayton@kernel.org>

