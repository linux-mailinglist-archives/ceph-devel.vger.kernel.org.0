Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6BB103C90
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Nov 2019 14:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbfKTNuI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Nov 2019 08:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729591AbfKTNuI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 08:50:08 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAFAF224FC;
        Wed, 20 Nov 2019 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574257807;
        bh=8MASzYbjwSxOGgcHguNb03Och18lkleCkjaaMw+NQ1Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d3ZOLWMgAjt33jc+GKqisFgILdq5gpKoDlFor06DoNeHhIYYQ4LlhBlIcBIgU/mYp
         jbagpKblXPDkjYfSGzBPO7JQBH1GXSJZW86WdxYMSiOIcc9rWZqHvyF2Rmm6NgjXsc
         60IpGffvQlwHa/GIb3FhcVawSUrSVhCHohx+eIP0=
Message-ID: <23c18302b3b9e730e304fde39d07477ef29faf1c.camel@kernel.org>
Subject: Re: [PATCH 0/3] mdsmap: fix mds choosing
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 20 Nov 2019 08:50:05 -0500
In-Reply-To: <20191120082902.38666-1-xiubli@redhat.com>
References: <20191120082902.38666-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-11-20 at 03:28 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Xiubo Li (3):
>   mdsmap: add more debug info when decoding
>   mdsmap: fix mdsmap cluster available check based on laggy number
>   mdsmap: only choose one MDS who is in up:active state without laggy
> 
>  fs/ceph/mds_client.c |  6 ++++--
>  fs/ceph/mdsmap.c     | 27 ++++++++++++++++++---------
>  2 files changed, 22 insertions(+), 11 deletions(-)
> 

These all look good to me. I'll plan to merge them for v5.5, unless
anyone else sees issues with them.

Thanks! 
-- 
Jeff Layton <jlayton@kernel.org>

