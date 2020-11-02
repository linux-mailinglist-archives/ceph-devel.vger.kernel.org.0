Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B012A2FE1
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Nov 2020 17:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgKBQdr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Nov 2020 11:33:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:51782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKBQdq (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Nov 2020 11:33:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604334826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=1vR1qD3F6QnP9x9mmK5DSHzXQDkXHp471P/cZiyYY3Q=;
        b=jEJmRaZo7t6Nm7tQOsSFYX5tT7ZuVYQYLS9yO/oB2X/luXRnReiGJ8mXan3lZFNl+0zmxF
        //ATSSwlPuiqd6aYGYOaQI6/3MOqnseMgE99awwBD0GtRFbPj9eavuIqFof06icK0uZAI8
        1OP6jmkdU1RrdEo0mtpBWmPO0kogSOk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DE4B9ACAA;
        Mon,  2 Nov 2020 16:33:45 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel <ceph-devel@vger.kernel.org>, ceph-maintainers@ceph.io
Subject: v14.2.13 Nautilus released
Date:   Mon, 02 Nov 2020 17:33:44 +0100
Message-ID: <87lffj7m6v.fsf@nautilus.suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


This is the 13th backport release in the Nautilus series. This release fixes a
regression introduced in v14.2.12, and a few ceph-volume & RGW fixes. We
recommend users to update to this release.

Notable Changes
---------------

* Fixed a regression that caused breakage in clusters that referred to ceph-mon
  hosts using dns names instead of ip addresses in the `mon_host` param in
  `ceph.conf` (issue#47951)
* ceph-volume: the ``lvm batch`` subcommand received a major rewrite

Changelog
---------
* ceph-volume: major batch refactor (pr#37522, Jan Fajerski)
* mgr/dashboard: Proper format iSCSI target portals (pr#37060, Volker Theile)
* rpm: move python-enum34 into rhel 7 conditional (pr#37747, Nathan Cutler)
* mon/MonMap: fix unconditional failure for init_with_hosts (pr#37816, Nathan Cutler, Patrick Donnelly)
* rgw: allow rgw-orphan-list to note when rados objects are in namespace (pr#37799, J. Eric Ivancich)
* rgw: fix setting of namespace in ordered and unordered bucket listing (pr#37798, J. Eric Ivancich)

--
Abhishek 
