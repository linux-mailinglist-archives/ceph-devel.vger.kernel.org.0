Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD08697DC0
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Aug 2019 16:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfHUO4F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Aug 2019 10:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbfHUO4F (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 10:56:05 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DD2322DA7;
        Wed, 21 Aug 2019 14:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566399364;
        bh=APX9oYgfMcCttw7k//9RC2boW6/rKHw9vg9w72eq77E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ObBpbEEeGdjb6ygz7D55qu/mdsv6hqpegLZGTtM5o2bvQ6cEbSx3vF061QeOeaRt7
         k7q6LGByEr6OV1+U+k2xh2YYgOemkh2IP5xmYw2Z9CKKQODHj6wHnP/FJg1Gyfo+qk
         CO43Q/OPzzgL/n1WkFq0AWfMD/nxqMIfNrGM0uzw=
Message-ID: <440be5fd413175262626143db50d9489806986f1.camel@kernel.org>
Subject: Re: [PATCH] libceph: fix PG split vs OSD (re)connect race
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Sage Weil <sage@redhat.com>, Jerry Lee <leisurelysw24@gmail.com>
Date:   Wed, 21 Aug 2019 10:56:02 -0400
In-Reply-To: <20190821120724.23614-1-idryomov@gmail.com>
References: <20190821120724.23614-1-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-08-21 at 14:07 +0200, Ilya Dryomov wrote:
> We can't rely on ->peer_features in calc_target() because it may be
> called both when the OSD session is established and open and when it's
> not.  ->peer_features is not valid unless the OSD session is open.  If
> this happens on a PG split (pg_num increase), that could mean we don't
> resend a request that should have been resent, hanging the client
> indefinitely.
> 
> In userspace this was fixed by looking at require_osd_release and
> get_xinfo[osd].features fields of the osdmap.  However these fields
> belong to the OSD section of the osdmap, which the kernel doesn't
> decode (only the client section is decoded).
> 
> Instead, let's drop this feature check.  It effectively checks for
> luminous, so only pre-luminous OSDs would be affected in that on a PG
> split the kernel might resend a request that should not have been
> resent.  Duplicates can occur in other scenarios, so both sides should
> already be prepared for them: see dup/replay logic on the OSD side and
> retry_attempt check on the client side.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7de030d6b10a ("libceph: resend on PG splits if OSD has RESEND_ON_SPLIT")
> Reported-by: Jerry Lee <leisurelysw24@gmail.com>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  net/ceph/osd_client.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index fed6b0334609..4e78d1ddd441 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -1514,7 +1514,7 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
>  	struct ceph_osds up, acting;
>  	bool force_resend = false;
>  	bool unpaused = false;
> -	bool legacy_change;
> +	bool legacy_change = false;
>  	bool split = false;
>  	bool sort_bitwise = ceph_osdmap_flag(osdc, CEPH_OSDMAP_SORTBITWISE);
>  	bool recovery_deletes = ceph_osdmap_flag(osdc,
> @@ -1602,15 +1602,14 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
>  		t->osd = acting.primary;
>  	}
>  
> -	if (unpaused || legacy_change || force_resend ||
> -	    (split && con && CEPH_HAVE_FEATURE(con->peer_features,
> -					       RESEND_ON_SPLIT)))
> +	if (unpaused || legacy_change || force_resend || split)
>  		ct_res = CALC_TARGET_NEED_RESEND;
>  	else
>  		ct_res = CALC_TARGET_NO_ACTION;
>  
>  out:
> -	dout("%s t %p -> ct_res %d osd %d\n", __func__, t, ct_res, t->osd);
> +	dout("%s t %p -> %d%d%d%d ct_res %d osd%d\n", __func__, t, unpaused,
> +	     legacy_change, force_resend, split, ct_res, t->osd);
>  	return ct_res;
>  }
>  

Reviewed-by: Jeff Layton <jlayton@kernel.org>

