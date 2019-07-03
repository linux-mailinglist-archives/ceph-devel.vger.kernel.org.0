Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6515E744
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 16:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfGCO7s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 10:59:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44688 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfGCO7s (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 10:59:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92E3CC01F28C;
        Wed,  3 Jul 2019 14:59:48 +0000 (UTC)
Received: from ovpn-112-39.rdu2.redhat.com (ovpn-112-39.rdu2.redhat.com [10.10.112.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 295B17C5CA;
        Wed,  3 Jul 2019 14:59:48 +0000 (UTC)
Date:   Wed, 3 Jul 2019 14:59:47 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     ceph-devel@vger.kernel.org
cc:     dev@ceph.io
Subject: Completing migration to dev@ceph.io
Message-ID: <alpine.DEB.2.11.1907031457420.2617@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 03 Jul 2019 14:59:48 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We created dev@ceph.io several weeks back.  There has been plenty of 
time now for everyone to get subscribed, so please now direct all dev 
discussion for Ceph proper to dev@ceph.io and use this list for 
ceph kernel client development only.  Avoid copying both lists unless the 
discussion is relevant both for userspace and the kernel.

https://lists.ceph.io/postorius/lists/dev.ceph.io/

Thanks!
sage
