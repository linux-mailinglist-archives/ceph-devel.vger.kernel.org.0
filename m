Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E0E3778D
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 17:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfFFPO2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 11:14:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729086AbfFFPO2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 11:14:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A348E31628F2;
        Thu,  6 Jun 2019 15:14:28 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 36AA67D67C;
        Thu,  6 Jun 2019 15:14:28 +0000 (UTC)
Date:   Thu, 6 Jun 2019 15:14:27 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: octopus planning calls
Message-ID: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 06 Jun 2019 15:14:28 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi everyone,

We'd like to do some planning calls for octopus.  Each call would be 30-60 
minutes, and cover (at least) rados, rbd, rgw, and cephfs.  The dashboard 
team has a face to face meeting next week in Germany so they should be in 
good shape.  Sebastian, do we need to schedule something on the 
orchestrator, or just rely on the existing Monday call?

1- Does the 1500-1700 UTC time range work well enough for everyone?  We'll 
record the calls, of course, and send an email summary after.

2- What day(s):

 Tomorrow (Friday Jun 7)
 Next week (Jun 10-14... may conflict with dashboard f2f)
 The following week (Jun 17-21)

If notice isn't too short for tomorrow or Monday, it might be nice to have 
some clarity for the dashboard folks going into their f2f as far as what 
underlying work and new features are in the pipeline.

Maybe... RADOS and RBD tomorrow, CephFS and RGW Monday?  Is that too much 
of a stretch?

sage
 
