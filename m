Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6CC301A9
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 20:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfE3SRW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 14:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3SRW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 May 2019 14:17:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E929E307D910
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 18:17:21 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A1D85F7E5
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 18:17:21 +0000 (UTC)
Date:   Thu, 30 May 2019 18:17:20 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     ceph-devel@vger.kernel.org
Subject: CDM next Wednesday: multi-site rbd and cephfs; rados progress
 events
Message-ID: <alpine.DEB.2.11.1905301812380.29593@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 30 May 2019 18:17:21 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

An initial agenda is up for the Ceph Developer Monthly call next 
Wednesday:

	https://tracker.ceph.com/projects/ceph/wiki/CDM_05-JUN-2019

The call will be at 1630 UTC (12:30pm ET) on Wed June 5th.

 https://bluejeans.com/908675367

The current agenda includes:

- RBD cloud migration (streamling migration of RBD images between 
  clusters)
- CephFS snap mirroring (disaster recovery solution for cephfs across 
  clusters)
- RADOS progress module (better events in 'ceph -s' to show progress bars 
  for things like cluster recovery)

If there are any other pending design discussions for Octopus, feel 
free to add them to the agenda or reply to this thread.

We're also planning on doing a series of planning meetings to decide what 
is in scope for Octopus (to be released in November).  Those will be 
announced shortly...

sage
