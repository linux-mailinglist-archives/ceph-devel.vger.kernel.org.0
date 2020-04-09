Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C391A38FC
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Apr 2020 19:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgDIRgc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Apr 2020 13:36:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:51386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgDIRgc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 13:36:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BBCEFAD63;
        Thu,  9 Apr 2020 17:36:30 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 09 Apr 2020 19:36:31 +0200
From:   Abhishek <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org, ceph-maintainers@ceph.io
Subject: v15.2.1 Octopus released
Message-ID: <57f63719d6aaa7990b158e657b2fa822@suse.com>
X-Sender: abhishek@suse.com
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is the first bugfix release of Ceph Octopus, we recommend all 
Octopus users
upgrade. This release fixes an upgrade issue and also has 2 security 
fixes

Notable Changes
~~~~~~~~~~~~~~~

* issue#44759: Fixed luminous->nautilus->octopus upgrade asserts
* CVE-2020-1759: Fixed nonce reuse in msgr V2 secure mode
* CVE-2020-1760: Fixed XSS due to RGW GetObject header-splitting

For the full changelog please refer to the official release blog entry 
at https://ceph.io/releases/v15-2-1-octopus-released/, for upgrades from 
previous versions, please follow the relevant section of the upgrade 
docs at 
https://docs.ceph.com/docs/master/releases/octopus/#upgrading-from-mimic-or-nautilus


Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-15.2.1.tar.gz
* For packages, see 
http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 9fd2f65f91d9246fae2c841a6222d34d121680ee
