Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF93617395C
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Feb 2020 15:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgB1OBc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Feb 2020 09:01:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:59010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727515AbgB1OBb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 09:01:31 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0DAA246B9;
        Fri, 28 Feb 2020 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582898491;
        bh=A5fb38kM+GZ7gGMNs4Lmp1mxfiq8mi+VBCVLWTrcR14=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ShUkFuMzDJfu2PbgZ4VEtk1Am3iJeV9fsCVrhVrw31NjSH6CrisH/hs+++80/Tl6+
         3JNQ3wg1kyboVYdlkwy42/7kNug4Wo0o1TJIy7bEMyKiIXqVdD4zocbIWTLo0etxPo
         tIl5hHDpPDrbC2LqQxeX1B6OciD9kpl5G0eBLaAA=
Message-ID: <6567c8fa690d9f9a0682ee22e528fcd5e3b51212.camel@kernel.org>
Subject: Re: libceph: follow redirect replies from osds
From:   Jeff Layton <jlayton@kernel.org>
To:     Colin Ian King <colin.king@canonical.com>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.co>,
        ceph-devel@vger.kernel.org
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Fri, 28 Feb 2020 09:01:29 -0500
In-Reply-To: <6ea7e486-a3f3-7def-1f88-2e645e3b9780@canonical.com>
References: <6ea7e486-a3f3-7def-1f88-2e645e3b9780@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-02-28 at 12:46 +0000, Colin Ian King wrote:
> Hi,
> 
> Static analysis with Coverity has detected a potential issue in the
> following commit in function ceph_redirect_decode():
> 
> commit 205ee1187a671c3b067d7f1e974903b44036f270
> Author: Ilya Dryomov <ilya.dryomov@inktank.com>
> Date:   Mon Jan 27 17:40:20 2014 +0200
> 
>     libceph: follow redirect replies from osds
> 
> The issue is as follows:
> 
> 
> 3486        len = ceph_decode_32(p);
> 
> Unused value (UNUSED_VALUE)
> assigned_pointer: Assigning value from len to *p here, but that stored
> value is overwritten before it can be used.
> 
> 3487        *p += len; /* skip osd_instructions */
> 3488
> 3489        /* skip the rest */
> 
> value_overwrite: Overwriting previous write to *p with value from
> struct_end.
> 
> 3490        *p = struct_end;
> 
> The *p assignment in line 3487 is effectively being overwritten by the
> *p assignment in 3490.  Maybe the following is correct:
> 
>         len = ceph_decode_32(p);
> -       p += len; /* skip osd_instructions */
> +       struct_end = *p + len;  /* skip osd_instructions */
> 
>         /* skip the rest */
>         *p = struct_end;
> 
> I'm not familiar with the ceph structure here, so I'm not sure what the
> correct fix would be.
> 

Probably something like this? (untested, of course)

----------------------

[PATCH] libceph: fix up Coverity warning in ceph_redirect_decode

We're going to skip to the end of the msg after checking the
object_name anyway, so there is no need to separately decode
the osd instructions that follow it.

Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/osd_client.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 8ff2856e2d52..51810db4130a 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3483,9 +3483,6 @@ static int ceph_redirect_decode(void **p, void
*end,
 		goto e_inval;
 	}
 
-	len = ceph_decode_32(p);
-	*p += len; /* skip osd_instructions */
-
 	/* skip the rest */
 	*p = struct_end;
 out:
-- 
2.24.1




