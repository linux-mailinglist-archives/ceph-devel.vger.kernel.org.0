Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC0B224ADB
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Jul 2020 13:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgGRLAI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 18 Jul 2020 07:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgGRLAI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 18 Jul 2020 07:00:08 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D59420724;
        Sat, 18 Jul 2020 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595070007;
        bh=v1VP/OxkJUoX6THkQa7EpUrUMR0lBDTUozKcV1kWebM=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=jkItOKJA11mSMNIHdihUjj6tsdxELc9YIEAE2GyFt/UdhaAHRNHTjXA/T+YH+BzKL
         Ytkb7/Y/MhxMIR5AqRJqYFc/9BLNQu5p+dyNAhlNwtthjcfqmLnuWRNVbriAzmrsCB
         sO8rYnPk1F2Yo47tPsjxAPIMBaBQ7gGF1zibI4Wo=
Message-ID: <db5f0447a43c9820a020d1dfcb80637029e4e516.camel@kernel.org>
Subject: Re: [PATCH] ceph: ceph_features.h: drop duplicated word in a comment
From:   Jeff Layton <jlayton@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Sat, 18 Jul 2020 07:00:06 -0400
In-Reply-To: <37c50064-e4ee-d79f-5a9f-2824479b01ca@infradead.org>
References: <37c50064-e4ee-d79f-5a9f-2824479b01ca@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-07-17 at 16:36 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Drop the doubled word "the" in a comment.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: ceph-devel@vger.kernel.org
> ---
>  include/linux/ceph/ceph_features.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20200714.orig/include/linux/ceph/ceph_features.h
> +++ linux-next-20200714/include/linux/ceph/ceph_features.h
> @@ -58,7 +58,7 @@
>   *    because 10.2.z (jewel) did not care if its peers advertised this
>   *    feature bit.
>   *
> - *  - In the second phase we stop advertising the the bit and call it
> + *  - In the second phase we stop advertising the bit and call it
>   *    RETIRED.  This can normally be done in the *next* major release
>   *    following the one in which we marked the feature DEPRECATED.  In
>   *    the above example, for 12.0.z (luminous) we can say:
> 

Merged into the testing branch. Thanks, Randy!
-- 
Jeff Layton <jlayton@kernel.org>

