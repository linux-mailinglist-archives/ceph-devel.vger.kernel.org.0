Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429A91EA250
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jun 2020 12:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFAK5G (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jun 2020 06:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgFAK5F (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 1 Jun 2020 06:57:05 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0F020679;
        Mon,  1 Jun 2020 10:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591009025;
        bh=IxYCAdde6w7CqZsSaB/U/Ya1J1e+IucL8AAhskFzlZs=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=bcFzbRwoiy92U++Nz+AEFxB1vRJ2zyCkHQHleLrExiiA4anpughM2USeNSSbACxuS
         omJ9/rhMXTxMEshzC5td1Lx+QDMt3G6tQN7Ml/myHCs308iVM4w9KpXunP0G7Zei2W
         0Yx18/133ZHv+uwQpXE1nfFAcv+urVN4+hBkaK54=
Message-ID: <7f4f76112da312feec94f03e024ce96f8ad37e8f.camel@kernel.org>
Subject: Re: [PATCH v2 0/5] libceph: support for replica reads
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Mon, 01 Jun 2020 06:57:03 -0400
In-Reply-To: <20200530153439.31312-1-idryomov@gmail.com>
References: <20200530153439.31312-1-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2020-05-30 at 17:34 +0200, Ilya Dryomov wrote:
> Hello,
> 
> This adds support for replica reads (balanced and localized reads)
> to rbd and ceph.  crush_location syntax is slightly different, see
> patch 3 for details.
> 
> v1 -> v2:
> - change crush_location syntax
> - rename read_policy to read_from_replica, add read_from_replica=no
> - crush_location and read_from_replica are now overridable
> 
> Thanks,
> 
>                 Ilya
> 
> 
> Ilya Dryomov (5):
>   libceph: add non-asserting rbtree insertion helper
>   libceph: decode CRUSH device/bucket types and names
>   libceph: crush_location infrastructure
>   libceph: support for balanced and localized reads
>   libceph: read_from_replica option
> 
>  include/linux/ceph/libceph.h    |  13 +-
>  include/linux/ceph/osd_client.h |   1 +
>  include/linux/ceph/osdmap.h     |  19 +-
>  include/linux/crush/crush.h     |   6 +
>  net/ceph/ceph_common.c          |  75 +++++++
>  net/ceph/crush/crush.c          |   3 +
>  net/ceph/debugfs.c              |   6 +-
>  net/ceph/osd_client.c           |  92 +++++++-
>  net/ceph/osdmap.c               | 363 +++++++++++++++++++++++++++-----
>  9 files changed, 517 insertions(+), 61 deletions(-)
> 

Nice work, Ilya. This all looks good to me now. The new mount option
syntax is much more readable.

It might be nice to sprinkle in some comments about the locking around
the new rbtrees (and maybe the existing DEFINE_RB_FUNCS trees), but
that's minor stuff.

You can add:

Reviewed-by: Jeff Layton <jlayton@kernel.org>

