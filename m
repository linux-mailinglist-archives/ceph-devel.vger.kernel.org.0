Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938231FB32A
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 16:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgFPOAm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 10:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgFPOAh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 16 Jun 2020 10:00:37 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72023207C3;
        Tue, 16 Jun 2020 14:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592316037;
        bh=zoV4CquxyTg6pcJ8SeW0EWrSqv+YChKRWt7wNbyorkc=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=sF0uv/Kl9wprvipTY7qcP7CKaBBwaEJSA8Lczajow+TcQhp1llc3qma7f8j87FEF9
         H61FBi5YdVJ/+HARcN4DlJZqQF4Qm90kKsgExjLW9V6vGIEKdSGGE04+xU1cwQKjui
         zGc8BG0vTIR5dhCM9DnUSUdfOMDUssQ9BU+Mgd6A=
Message-ID: <8d7ea3bf8b7d26dea1aae30054676d1309838784.camel@kernel.org>
Subject: Re: [PATCH] libceph: move away from global osd_req_flags
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Tue, 16 Jun 2020 10:00:36 -0400
In-Reply-To: <20200608075603.29053-1-idryomov@gmail.com>
References: <20200608075603.29053-1-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-06-08 at 09:56 +0200, Ilya Dryomov wrote:
> osd_req_flags is overly general and doesn't suit its only user
> (read_from_replica option) well:
> 
> - applying osd_req_flags in account_request() affects all OSD
>   requests, including linger (i.e. watch and notify).  However,
>   linger requests should always go to the primary even though
>   some of them are reads (e.g. notify has side effects but it
>   is a read because it doesn't result in mutation on the OSDs).
> 
> - calls to class methods that are reads are allowed to go to
>   the replica, but most such calls issued for "rbd map" and/or
>   exclusive lock transitions are requested to be resent to the
>   primary via EAGAIN, doubling the latency.
> 
> Get rid of global osd_req_flags and set read_from_replica flag
> only on specific OSD requests instead.
> 
> Fixes: 8ad44d5e0d1e ("libceph: read_from_replica option")
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  drivers/block/rbd.c          |  4 +++-
>  include/linux/ceph/libceph.h |  4 ++--
>  net/ceph/ceph_common.c       | 14 ++++++--------
>  net/ceph/osd_client.c        |  3 +--
>  4 files changed, 12 insertions(+), 13 deletions(-)

Looks reasonable:

Reviewed-by: Jeff Layton <jlayton@kernel.org>

