Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3A0B4FCB
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Sep 2019 16:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfIQOAa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Sep 2019 10:00:30 -0400
Received: from yourcmc.ru ([195.209.40.11]:47322 "EHLO yourcmc.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbfIQOA3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 10:00:29 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2019 10:00:29 EDT
Received: from yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id CBBFEFE0656;
        Tue, 17 Sep 2019 16:53:42 +0300 (MSK)
Received: from webmail.yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id 9B60BFE00CA;
        Tue, 17 Sep 2019 16:53:42 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 17 Sep 2019 16:53:42 +0300
From:   vitalif@yourcmc.ru
To:     Janne Johansson <icepic.dz@gmail.com>
Cc:     Alfredo Deza <adeza@redhat.com>, ceph-maintainers@ceph.com,
        ceph-users <ceph-users@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: [ceph-users] Re: download.ceph.com repository changes
Message-ID: <85125aa8abc7a62e4c4d00a65b1bc9fe@yourcmc.ru>
X-Sender: vitalif@yourcmc.ru
User-Agent: Roundcube Webmail/1.2.3
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The worst part about the official repository is that it lacks Debian 
packages

Also of course it would be very convenient to be able to install any 
version from the repos, not just the latest one. It's certainly possible 
with debian repos...
