Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36FFA19F24
	for <lists+ceph-devel@lfdr.de>; Fri, 10 May 2019 16:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfEJO1P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 May 2019 10:27:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727896AbfEJO1O (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 May 2019 10:27:14 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0779E30821B5;
        Fri, 10 May 2019 14:27:13 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D6005D9D4;
        Fri, 10 May 2019 14:27:12 +0000 (UTC)
Date:   Fri, 10 May 2019 14:27:11 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     ceph-devel@vger.kernel.org, ceph-users@ceph.com
Subject: RFC: relicence Ceph LGPL-2.1 code as LGPL-2.1 or LGPL-3.0
Message-ID: <alpine.DEB.2.11.1904221623540.7135@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 10 May 2019 14:27:14 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi everyone,

-- What --

The Ceph Leadership Team[1] is proposing a change of license from 
*LGPL-2.1* to *LGPL-2.1 or LGPL-3.0* (dual license). The specific changes 
are described by this pull request:

	https://github.com/ceph/ceph/pull/22446

If you are a Ceph developer who has contributed code to Ceph and object to 
this change of license, please let us know, either by replying to this 
message or by commenting on that pull request.

Our plan is to leave the issue open for comment for some period of time 
and, if no objections are raised that cannot be adequately addressed (via 
persuasion, code replacement, or whatever) we will move forward with the 
change.


-- Why --

The primary motivation to relicense is a desire to integrate with projects 
that are licensed under the Apache License version 2.0. Although opinions 
vary, there are some who argue the the LGPL-2.1 and Apache-2.0 licenses 
are not fully compatible. We would like to avoid the ambiguity and 
potential for controversy.

Projects we would like to consume that are Apache-2.0 licensed include 
RocksDB, Seastar, OpenSSL (which is in the process of relicensing to 
Apache-2.0), and Swagger (swagger.io). Note that some of these are (or 
could be) dynamically linked or are consumed via a high-level language, 
and may or may not require a change to LGPL-3.0, but providing the option 
for LGPL-3.0 will avoid any uncertainty.

A few other source files are already incorporated into Ceph that claim an 
Apache-2.0 license:

   src/common/deleter.h
   src/common/sstring.h
   src/include/cpp-btree

The Ceph developers would further like to provide a license option that is 
more modern than the current LGPL-2.1. LGPL-3.0 includes updated, 
clarified language around several issues and is widely considered more 
modern, superior license.

Thank you!


[1] http://docs.ceph.com/docs/master/governance/#ceph-leadership-team
