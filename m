Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9503176591
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Mar 2020 22:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgCBVHQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Mar 2020 16:07:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgCBVHQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 16:07:16 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3234421556;
        Mon,  2 Mar 2020 21:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583183235;
        bh=2sxtUKJmFd/q0QN8SlELEfQ0v+EOLNSb1qD02RvBb5Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A8SZ9iKo62y2Ckk97dLDmCoiJcFyufCsg9mf60QbDZjp5HAMNOv4pC9e/CKIolRSl
         m3ILUUPTh0sZCdVp7jD1pi9Bftd4wFx3AdAiPhcVb1p5IXFapU/mQiipw5xr67IkIV
         QDvG4hmg3eCvTJ0E2UCjlWqBImtmg0AX15H/XlGI=
Message-ID: <ecf67b60b2549264dd8e8fcfef432ab93e7285f9.camel@kernel.org>
Subject: Re: [PATCH v6 00/13] ceph: async directory operations support
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, pdonnell@redhat.com
Date:   Mon, 02 Mar 2020 16:07:14 -0500
In-Reply-To: <544d98ca-6dc9-bcda-3f99-ff87f646265c@redhat.com>
References: <20200302141434.59825-1-jlayton@kernel.org>
         <544d98ca-6dc9-bcda-3f99-ff87f646265c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-03-03 at 00:22 +0800, Yan, Zheng wrote:
> Reviewed-by: "Yan, Zheng" <zyan@redhat.com>

Thanks Zheng, merged into "testing".
-- 
Jeff Layton <jlayton@kernel.org>

