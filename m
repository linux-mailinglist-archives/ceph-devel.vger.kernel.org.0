Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599F52BC305
	for <lists+ceph-devel@lfdr.de>; Sun, 22 Nov 2020 02:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgKVBqY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 21 Nov 2020 20:46:24 -0500
Received: from p-impout005aa.msg.pkvw.co.charter.net ([47.43.26.136]:46126
        "EHLO p-impout005.msg.pkvw.co.charter.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726431AbgKVBqX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 21 Nov 2020 20:46:23 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2020 20:46:23 EST
Received: from JohnDoey ([72.238.163.129])
        by cmsmtp with ESMTP
        id geLSkSE4UhO0AgeLSknbdy; Sun, 22 Nov 2020 01:39:15 +0000
X-Authority-Analysis: v=2.3 cv=e/Z4tph/ c=1 sm=1 tr=0
 a=AF3om7igN0MtrSvtt3SMSA==:117 a=AF3om7igN0MtrSvtt3SMSA==:17
 a=kj9zAlcOel0A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=A2VhLGvBAAAA:20
 a=4u6H09k7AAAA:8 a=2hwutZsgUbuUs8y5dAoA:9 a=CjuIK1q_8ugA:10 a=sOfu8i_z1jgA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=5yerskEF2kbSkDMynNst:22
From:   "Brent Kennedy" <bkennedy@cfl.rr.com>
To:     "'David Galloway'" <dgallowa@redhat.com>, <ceph-announce@ceph.io>,
        <ceph-users@ceph.io>, <dev@ceph.io>, <ceph-devel@vger.kernel.org>,
        <ceph-maintainers@ceph.io>
References: <9b6eefd1-e6f9-ddc2-2eed-6ecba00fb982@redhat.com>
In-Reply-To: <9b6eefd1-e6f9-ddc2-2eed-6ecba00fb982@redhat.com>
Subject: RE: [ceph-users] v15.2.6 Octopus released
Date:   Sat, 21 Nov 2020 20:39:14 -0500
Message-ID: <009401d6c070$492749b0$db75dd10$@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJfMhfFrkUc3D5hvYi6DTJKzq4yqajCfC3Q
Content-Language: en-us
X-CMAE-Envelope: MS4wfD0MGnPa5s8EtR07rznuy7qlu4tpwTSRXqXjr8F2AU4hz+caCaKOhmogx+NSqWrcKmWKAFobhyrMBjouDdiQp2X5//esMG6yFnW4zaZgp+55pY54INCn
 VBzS5gnq9kCTyGMJJ/UqDxVAoFod/CMvI7OQS4GyKam8HruHLggNPmTBk7j4E5vnHGJTeaoMo4fN1355n0eXaymbFBz66aY5WxGB4TUJ9D9pjnieT2z7E0or
 SfzE3VqYX2o69S+cHCXTpdugA2yhg3e+9PpeoJWxGB2YSi4MHOlW8rpE4Dk8GRQUX7i/fxtK5u22/Zo5b/3INKvTlhX7uhIAOPCClvGXrn0=
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

FYI, ceph-ansible has a problem due to ceph-volume , so don't do it via the
rolling-upgrade.yml script.

-Brent

-----Original Message-----
From: David Galloway <dgallowa@redhat.com> 
Sent: Wednesday, November 18, 2020 9:39 PM
To: ceph-announce@ceph.io; ceph-users@ceph.io; dev@ceph.io;
ceph-devel@vger.kernel.org; ceph-maintainers@ceph.io
Subject: [ceph-users] v15.2.6 Octopus released

This is the 6th backport release in the Octopus series. This releases fixes
a security flaw affecting Messenger V2 for Octopus & Nautilus. We recommend
users to update to this release.

Notable Changes
---------------
* CVE 2020-25660: Fix a regression in Messenger V2 replay attacks


Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-15.2.6.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: cb8c61a60551b72614257d632a574d420064c17a
_______________________________________________
ceph-users mailing list -- ceph-users@ceph.io To unsubscribe send an email
to ceph-users-leave@ceph.io

