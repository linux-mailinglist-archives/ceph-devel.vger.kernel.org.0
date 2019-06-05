Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B5436301
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 19:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfFERvr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 13:51:47 -0400
Received: from mx2.bfh.ch ([147.87.250.53]:47042 "EHLO mx2.bfh.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbfFERvr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 13:51:47 -0400
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jun 2019 13:51:46 EDT
Received: from MAIL24.bfh.ch (mail24.bfh.ch [147.87.245.164])
        by mx2.bfh.ch (8.14.4/8.14.4/Debian-4) with ESMTP id x55HbTOR015588
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jun 2019 19:37:29 +0200
Received: from [10.8.0.14] (147.87.245.141) by MAIL24.bfh.ch (147.87.245.164)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Wed, 5 Jun 2019
 19:37:28 +0200
Reply-To: <daniel.baumann@bfh.ch>
Subject: Re: [ceph-users] Changing the release cadence
To:     <ceph-users@ceph.com>
References: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal>
CC:     <ceph-devel@vger.kernel.org>, <dev@ceph.io>
From:   Daniel Baumann <daniel.baumann@bfh.ch>
Message-ID: <d713faee-ae2f-5022-1fd2-2fd9b0a2e39d@bfh.ch>
Date:   Wed, 5 Jun 2019 19:37:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.87.245.141]
X-ClientProxiedBy: MAIL23.bfh.ch (147.87.245.163) To MAIL24.bfh.ch
 (147.87.245.164)
X-Bayes-Prob: 0.0001 (Score 0, tokens from: outbound, bfh:default, base:default, @@RPTN)
X-Spam-Score: 0.00 () [Hold at 10.00] 
X-CanIt-Geo: ip=147.87.245.164; country=CH; region=Bern; city=Bern; latitude=46.9312; longitude=7.4866; http://maps.google.com/maps?q=46.9312,7.4866&z=6
X-CanItPRO-Stream: bfh:outbound (inherits from bfh:default,base:default)
X-Canit-Stats-ID: 030l5BtAI - 435714beeb61 - 20190605
X-CanIt-Archive-Cluster: gbKgvJ3SmUdnfmr4CnDUWvXR30M
X-Scanned-By: CanIt (www . roaringpenguin . com) on 147.87.250.53
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 6/5/19 5:57 PM, Sage Weil wrote:
> So far the balance of opinion seems to favor a shift to a 12 month 
> cycle [...] it seems pretty likely we'll make that shift.

thanks, much appreciated (from an cluster operating point of view).

> Thoughts?

GNOME and a few others are doing April and October releases which seems
balanced and to be good timing for most people; personally I prefer
spring rather than autum for upgrades, hence.. would suggest April.

Regards,
Daniel
