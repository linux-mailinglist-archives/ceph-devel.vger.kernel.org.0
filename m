Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7AC31181
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2019 17:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfEaPpj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 May 2019 11:45:39 -0400
Received: from ppsw-30.csi.cam.ac.uk ([131.111.8.130]:52184 "EHLO
        ppsw-30.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfEaPpj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 31 May 2019 11:45:39 -0400
X-Greylist: delayed 1160 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 11:45:39 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cam.ac.uk;
         s=20180806.ppsw; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rShHerz3ZYbQOzZFDteLKWZ+7EjCJ/gnPp6G2MN/9Js=; b=saMzG2nMVGwhI+c6hGMSOTiMg6
        wK7LeY3tUu1hqHXMtXKVyFnNI/oRdy1QoX2hFsegS69h9HvaJX8dWNEitU+edMbewFLi08V5uX1Qe
        hwIDTzrkytAslxuEZGze/77m783CwCsA8SSg3QXxPOhkqo39vokbmldAuJDXn1MOEytQ=;
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://help.uis.cam.ac.uk/email-scanner-virus
Received: from mail.mrc-lmb.cam.ac.uk ([131.111.85.9]:39974 helo=mail.lmb.internal)
        by ppsw-30.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.136]:25)
        with esmtp id 1hWjQA-000at4-eW (Exim 4.91)
        (return-path <jog@mrc-lmb.cam.ac.uk>); Fri, 31 May 2019 16:26:18 +0100
Received: from pcterm01.lmb.internal ([10.91.192.36])
        by mail.lmb.internal with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jog@mrc-lmb.cam.ac.uk>)
        id 1hWjQA-001AkI-FM; Fri, 31 May 2019 16:26:18 +0100
Subject: Re: cephfs snapshot mirroring
To:     Sage Weil <sweil@redhat.com>, ceph-devel@vger.kernel.org
References: <alpine.DEB.2.11.1905302154350.29593@piezo.novalocal>
From:   Jake Grimmett <jog@mrc-lmb.cam.ac.uk>
Message-ID: <0e9f1d96-d988-5a04-59fe-5110181e37de@mrc-lmb.cam.ac.uk>
Date:   Fri, 31 May 2019 16:26:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1905302154350.29593@piezo.novalocal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

As a sysadmin, I'd very much like to give a +1 on this.

We are currently building a new cephfs cluster, and plan to mirror the
new cluster to our older cephfs cluster. We would keep 30 days of daily
snapshots on the old system, and one snapshot on the main system to sync
from.

As Sage's notes in Part 4 suggest, we hope to ceph.dir.rctime to
identify "hot directories" to improve efficiency.

We would either use plain rsync, or a modified version of parsync
(http://moo.nac.uci.edu/~hjm/parsync/) to spin up multiple rsync worker
jobs.

If someone can modify rsync, so it reads the ceph.dir.rctime, and adds a
"ignore folders older than epoch" parameter, this would be a great start :)

all the best, and enjoy your weekend,

Jake


On 5/30/19 10:56 PM, Sage Weil wrote:
> This is on the agenda for CDM next week, but I wrote up some notes here:
> 
> 	https://pad.ceph.com/p/cephfs-snap-mirroring
> 
> It encompasses a few things besides just mirroring, starting with a set of 
> comamnds to set up cephfs snapshot schedules and retention/rotation 
> policy, which we need anyway, and seems related and like something we 
> should add before doing mirroring.
> 
> Thoughts?
> 
> sage
> 

