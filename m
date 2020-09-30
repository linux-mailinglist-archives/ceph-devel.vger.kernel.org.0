Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769F227F146
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Sep 2020 20:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgI3S0Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 30 Sep 2020 14:26:16 -0400
Received: from out.roosit.eu ([212.26.193.44]:38424 "EHLO out.roosit.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3S0P (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 14:26:15 -0400
Received: from sx.f1-outsourcing.eu (host-213.189.39.136.telnetsolutions.pl [213.189.39.136])
        by out.roosit.eu (8.14.7/8.14.7) with ESMTP id 08UIPxf2055841
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Wed, 30 Sep 2020 20:26:00 +0200
Received: from sx.f1-outsourcing.eu (localhost.localdomain [127.0.0.1])
        by sx.f1-outsourcing.eu (8.13.8/8.13.8) with ESMTP id 08UIPw5S004807;
        Wed, 30 Sep 2020 20:25:58 +0200
Date:   Wed, 30 Sep 2020 20:25:58 +0200
From:   "Marc Roos" <M.Roos@f1-outsourcing.eu>
To:     "icepic.dz" <icepic.dz@gmail.com>, tri <tri@postix.net>
cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Message-ID: <"H00000710017e5b3.1601490358.sx.f1-outsourcing.eu*"@MHS>
In-Reply-To: <cc1fd8b50bf1a0ede129bf0f5f47906e@postix.net>
Subject: RE: [ceph-users] Re: Understanding what ceph-volume does, with bootstrap-osd/ceph.keyring, tmpfs
x-scalix-Hops: 1
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Thanks!  

-----Original Message-----
To: Janne Johansson; Marc Roos
Cc: ceph-devel; ceph-users
Subject: Re: [ceph-users] Re: Understanding what ceph-volume does, with 
bootstrap-osd/ceph.keyring, tmpfs

The key is stored in the ceph cluster config db. It can be retrieved by

KEY=`/usr/bin/ceph --cluster ceph --name client.osd-lockbox.${OSD_FSID} 
--keyring $OSD_PATH/lockbox.keyring config-key get 
dm-crypt/osd/$OSD_FSID/luks`




