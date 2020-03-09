Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B619E17DF86
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 13:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgCIMJX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 08:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbgCIMJX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 08:09:23 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36795208C3;
        Mon,  9 Mar 2020 12:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583755762;
        bh=bvrFTKaQrAjVljytb5eRCl3PUbN7jeqiKOCMXrshCig=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=azRzSD3vMd5mDOpvdBLZkXGnXypX1Iu+gabPcTTxpRSE/RfBbMdQuaQzqp6H0H5zZ
         6rJ1RSOOsQ/v2kc36FL4q+7YJIin6tcfyy9iuynRo2sugGcI1ktgPyXseIKJo2fzOd
         7DgCr3rzNcgKmPGdhASC8EvSEe5XiZ42UqU/0qRU=
Message-ID: <5f1c8c66f573ce499a1232c2346f5baaff413a57.camel@kernel.org>
Subject: Re: [PATCH v9 0/5] ceph: add perf metrics support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 09 Mar 2020 08:09:21 -0400
In-Reply-To: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
References: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-03-09 at 03:37 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Changed in V9:
> - add an r_ended field to the mds request struct and use that to calculate the metric
> - fix some commit comments
> 
> We can get the metrics from the debugfs:
> 
> $ cat /sys/kernel/debug/ceph/0c93a60d-5645-4c46-8568-4c8f63db4c7f.client4267/metrics 
> item          total       sum_lat(us)     avg_lat(us)
> -----------------------------------------------------
> read          13          417000          32076
> write         42          131205000       3123928
> metadata      104         493000          4740
> 
> item          total           miss            hit
> -------------------------------------------------
> d_lease       204             0               918
> caps          204             213             368218
> 

Thanks Xiubo! This looks good. One minor issue with the cap patch, but I
can just fix that up before merging if you're ok with my proposed
change.

Beyond this...while average latency is a good metric, it's often not
enough to help diagnose problems. I wonder if we ought to be at least
tracking min/max latency for all calls too. I wonder if there's way to
track standard deviation too? That would be really nice to have.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

