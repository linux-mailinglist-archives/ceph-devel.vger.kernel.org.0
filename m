Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B669210AE7E
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2019 12:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfK0LH0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Nov 2019 06:07:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbfK0LH0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 06:07:26 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF972053B;
        Wed, 27 Nov 2019 11:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574852845;
        bh=GxvNAEs0uFHHB8z77yeadgkeitaaIbk3NmL8bBI8GkI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ODPi7msCfwNev6SWUYFTreozP5nQFvawy+AP3yrL+SYMz5flPGC0aX3qTq+uCZces
         tLUxPH2u+vjuQcxGzRXHIyjox9Ab44pH24vwiUq3fPTImmiW40M27jpEUJqeuNYkZO
         w6k4o1Z043hjWla+eysK1vPnssYK6mewmeXdqneY=
Message-ID: <f1ece18a6d78630b94cbc329b2c4c03136f480c0.camel@kernel.org>
Subject: Re: [PATCH v3 0/3] mdsmap: fix mds choosing
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, zyan@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Wed, 27 Nov 2019 06:07:23 -0500
In-Reply-To: <20191126122422.12396-1-xiubli@redhat.com>
References: <20191126122422.12396-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-11-26 at 07:24 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> V2:
> - ignore laggy for the auth mds case
> - for the random mds choosing, get one none laggy first and only
>   when there has no we will fall back to choose a laggy one if there
>   has.
> 
> V3:
> - add the mds sanity check
> 
> Xiubo Li (3):
>   mdsmap: add more debug info when decoding
>   mdsmap: fix mdsmap cluster available check based on laggy number
>   mdsmap: only choose one MDS who is in up:active state without laggy
> 
>  fs/ceph/mds_client.c        | 13 +++++--
>  fs/ceph/mdsmap.c            | 74 ++++++++++++++++++++-----------------
>  include/linux/ceph/mdsmap.h |  1 +
>  3 files changed, 51 insertions(+), 37 deletions(-)
> 

Ok, I think this looks sane enough. I'll merge it into the testing
branch and we'll see how it does.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

