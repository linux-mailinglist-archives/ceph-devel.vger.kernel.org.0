Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87FA1A2416
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 16:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgDHObN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Apr 2020 10:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728908AbgDHObM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Apr 2020 10:31:12 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7191F20B1F;
        Wed,  8 Apr 2020 14:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586356272;
        bh=tdUriesX2lwl8y1Yv0Uys2nb8BK6YfXv8InWY36V8uI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tmMzdEbWKbrVqIOCaJYZwfP9Wovaf2rqvxkxUssc4w0XcmFoUuI2BaUfOjZlXPlD2
         gGYXo03sfm9rlHanGavJW7T+pVCtGNBQnlkKN7cr5Wih4JsIrn32HmcK0lSHVFMZTD
         s3cUx73dpmBx4kwyBIgZ4YXTg4DDWGSWn/RQsc0Y=
Message-ID: <c0942c61c37e3f79dcc88ddba94d65aca2ca9a2c.camel@kernel.org>
Subject: Re: [PATCH v2 0/2] ceph: support cross-quota-tree renames
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Zheng Yan <zyan@redhat.com>
Cc:     Frank Schilder <frans@dtu.dk>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 08 Apr 2020 10:31:10 -0400
In-Reply-To: <20200407103020.22588-1-lhenriques@suse.com>
References: <20200407103020.22588-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-04-07 at 11:30 +0100, Luis Henriques wrote:
> Hi!
> 
> The following patches will make the cephfs kernel client behave the same
> way as the fuse client when doing renames across different quota realms.
> 
> Changes since v1:
> 
> - Dropped 'old == new' check in ceph_quota_check_rename() and added back
>   optimization in ceph_rename(), to only check realms if old_dir and
>   new_dir are different.
> 
> Luis Henriques (2):
>   ceph: normalize 'delta' parameter usage in check_quota_exceeded
>   ceph: allow rename operation under different quota realms
> 
>  fs/ceph/dir.c   |  9 +++----
>  fs/ceph/quota.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----
>  fs/ceph/super.h |  3 ++-
>  3 files changed, 65 insertions(+), 9 deletions(-)
> 

Looks good. Merged into ceph-client/testing.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

