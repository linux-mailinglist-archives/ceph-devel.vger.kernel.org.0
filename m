Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33044135B08
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 15:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731497AbgAIOGw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 09:06:52 -0500
Received: from yourcmc.ru ([195.209.40.11]:37050 "EHLO yourcmc.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgAIOGw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 09:06:52 -0500
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2020 09:06:52 EST
Received: from yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id 44CFFFE0656;
        Thu,  9 Jan 2020 16:58:14 +0300 (MSK)
Received: from webmail.yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id 19F09FE00CB;
        Thu,  9 Jan 2020 16:58:14 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 09 Jan 2020 16:58:13 +0300
From:   vitalif@yourcmc.ru
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     ceph-devel@vger.kernel.org, ceph-devel-owner@vger.kernel.org
Subject: Re: crimson-osd vs legacy-osd: should the perf difference be already
 noticeable?
In-Reply-To: <02e2209f66f18217aa45b8f7caf715f6@suse.de>
References: <02e2209f66f18217aa45b8f7caf715f6@suse.de>
Message-ID: <34d373cf1e08ed8480655969d0be63a4@yourcmc.ru>
X-Sender: vitalif@yourcmc.ru
User-Agent: Roundcube Webmail/1.2.3
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I watched some of their crimson osd mettings on youtube and they 
discussed something similar... however I thought they also said that 
crimson-osd eats less CPU cores during that test. Did it eat less CPU in 
your test?
