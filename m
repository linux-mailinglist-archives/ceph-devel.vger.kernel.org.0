Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A654A2299DD
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 16:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbgGVOOH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 22 Jul 2020 10:14:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:60506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbgGVOOH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 10:14:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B4D75ABCF;
        Wed, 22 Jul 2020 14:14:13 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org, ceph-maintainers@ceph.io
Subject: Mimic is retired
Date:   Wed, 22 Jul 2020 16:13:51 +0200
Message-ID: <877duv1vts.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


This is to announce the retirement of v13.2.X Mimic stable release
series, and there will no longer be any more backport releases to the
Mimic series. Any more patches to the mimic branch will have to be
tested by the developer submitting the patches and approved by the tech
lead of the respective component before merge to keep the branch stable.

The last release of Mimic was v13.2.10 released on Apr 2020. This is
keeping up with the active 2 stable releases and 24 month support cycle,
which is documented at
https://docs.ceph.com/docs/master/releases/general/#lifetime-of-stable-releases
Users are requested to upgrade to Nautilus or Octopus.

For the official blog post link please refer to
https://ceph.io/releases/mimic-is-retired/

--
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
GF: Felix Imendörffer, HRB 36809 (AG Nürnberg)
