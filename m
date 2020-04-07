Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4091A067C
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Apr 2020 07:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDGFUh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Apr 2020 01:20:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:24262 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgDGFUh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 01:20:37 -0400
IronPort-SDR: 2rT5kcVjP7dHYUlsOvUQbNJjnnlOvsw3gO5vX308jdPxhRUJXeNfkY4t8EptC5Ly98vGfva4VW
 JWrIlS1BQM4A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 22:20:37 -0700
IronPort-SDR: re4CsHbnnnAo8iEqTOa9IDkXGUF6Tinkr81N5FfH/3+dH5EuMUyA3At1j7aZOkt6rRaWgaOWpa
 Y5wPPYnMlHvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,353,1580803200"; 
   d="scan'208";a="286116920"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 06 Apr 2020 22:20:35 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jLgf5-0009ym-Dt; Tue, 07 Apr 2020 13:20:35 +0800
Date:   Tue, 7 Apr 2020 13:19:44 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org
Subject: [ceph-client:testing 2/4] fs/ceph/caps.c:4244:2-3: Unneeded semicolon
Message-ID: <202004071337.Kr4o9xHr%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   35d3521ea33df79af4358eb1e75f4d89316bf879
commit: ed8895ddd103b886380f70cae1592dd2332278c2 [2/4] ceph: convert mdsc->cap_dirty to a per-session list

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> fs/ceph/caps.c:4244:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
