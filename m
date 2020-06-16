Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7CA1FAF45
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 13:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgFPLd1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 07:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbgFPLd0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 16 Jun 2020 07:33:26 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0863E2098B;
        Tue, 16 Jun 2020 11:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592307206;
        bh=sy73SyN6PYX9C/ZaFR4NINQ2XWoAwVJLtFThkP/jHi4=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=cPyuaxTEFO0wKvD9ufjUuG4IxsJkKGge+hNVF4xyNbKEGk5+LoDF4XSd/Mkk8QJih
         tO0takv3guxK5vlMBSBH7bTVILC7AAnoiv6gDpMm+vOMBgv5rj2zbJJGQ4v2D2IY14
         vd7Cu+0a7U0t/NpGkS78MB8puylEgTY++0dd6iPk=
Message-ID: <e2ff602f1b643092eae1682ba770cadd31faefe3.camel@kernel.org>
Subject: Re: [PATCH 0/3] libceph: target_copy() fixups
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Tue, 16 Jun 2020 07:33:24 -0400
In-Reply-To: <20200616074415.9989-1-idryomov@gmail.com>
References: <20200616074415.9989-1-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-06-16 at 09:44 +0200, Ilya Dryomov wrote:
> Hello,
> 
> Split into three commits for backporting reasons: the first two can be
> picked up by stable, the third should get some soak time in testing.
> 
> Thanks,
> 
>                 Ilya
> 
> 
> Ilya Dryomov (3):
>   libceph: don't omit recovery_deletes in target_copy()
>   libceph: don't omit used_replica in target_copy()
>   libceph: use target_copy() in send_linger()
> 
>  net/ceph/osd_client.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

These all look sane to me:

Reviewed-by: Jeff Layton <jlayton@kernel.org>

