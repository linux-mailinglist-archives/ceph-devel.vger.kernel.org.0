Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8EA30452
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 23:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfE3V40 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 17:56:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbfE3V40 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 May 2019 17:56:26 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A93542E97C7
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 21:56:26 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52C161001DDE
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 21:56:26 +0000 (UTC)
Date:   Thu, 30 May 2019 21:56:25 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     ceph-devel@vger.kernel.org
Subject: cephfs snapshot mirroring
Message-ID: <alpine.DEB.2.11.1905302154350.29593@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 30 May 2019 21:56:26 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is on the agenda for CDM next week, but I wrote up some notes here:

	https://pad.ceph.com/p/cephfs-snap-mirroring

It encompasses a few things besides just mirroring, starting with a set of 
comamnds to set up cephfs snapshot schedules and retention/rotation 
policy, which we need anyway, and seems related and like something we 
should add before doing mirroring.

Thoughts?

sage
