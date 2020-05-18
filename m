Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7994D1D8922
	for <lists+ceph-devel@lfdr.de>; Mon, 18 May 2020 22:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgERU1d convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 18 May 2020 16:27:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:38946 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgERU1d (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 18 May 2020 16:27:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 67263AD66;
        Mon, 18 May 2020 20:27:34 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org, ceph-maintainers@ceph.io
Subject: v15.2.2 Octopus released
Date:   Mon, 18 May 2020 22:27:21 +0200
Message-ID: <87ftbx3s5y.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


We're happy to announce the second bugfix release of Ceph Octopus stable
release series, we recommend that all Octopus users upgrade. This
release has a range of fixes across all components and a security fix.

Notable Changes
---------------
* CVE-2020-10736: Fixed an authorization bypass in mons & mgrs (Olle
SegerDahl, Josh Durgin)

For the complete changelog please refer to the full release blog at
https://ceph.io/releases/v15-2-2-octopus-released/

Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-15.2.2.tar.gz
* For packages, see
http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 0c857e985a29d90501a285f242ea9c008df49eb8

-- 
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
GF: Felix Imendörffer, HRB 36809 (AG Nürnberg)
