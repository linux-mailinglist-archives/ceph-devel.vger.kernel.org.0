Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F111E8CF9
	for <lists+ceph-devel@lfdr.de>; Sat, 30 May 2020 03:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgE3B5M (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 21:57:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57140 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727876AbgE3B5M (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 21:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590803831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ympSXWIhISyEA8uJMerd2Af01Yo0V+7YTRWvv4gV0XA=;
        b=DLXa4LKyz3H42hqAq27UfL9x3+MA4xwQYDV+V/DQ/OnbFOeAAf24ox1tztbwCJ/W9VyRlZ
        I0ULzncmPlCdkrwLKLPxRdSB11RdgmXMxzxfMgPvHOVo7rHt0uDoNnBiM1aJapmVd5bRlU
        zLxAQKG7Qkm1LKmpGFxQimWF4hNIpeE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-4R9q-yNKPU2-xw7VBKvxdg-1; Fri, 29 May 2020 21:56:49 -0400
X-MC-Unique: 4R9q-yNKPU2-xw7VBKvxdg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EE6B107ACCD;
        Sat, 30 May 2020 01:56:48 +0000 (UTC)
Received: from [10.3.114.246] (ovpn-114-246.phx2.redhat.com [10.3.114.246])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FF0B78366;
        Sat, 30 May 2020 01:56:48 +0000 (UTC)
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel <ceph-devel@vger.kernel.org>, ceph-maintainers@ceph.io
From:   Josh Durgin <jdurgin@redhat.com>
Subject: v15.2.3 Octopus released
Message-ID: <0d1374f4-981a-30c4-a992-07b6c8f0db1c@redhat.com>
Date:   Fri, 29 May 2020 18:56:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We’re happy to announce the availability of the third Octopus stable
release series. This release mainly is a workaround for a potential OSD
corruption in v15.2.2. We advise users to upgrade to v15.2.3 directly.
For users running v15.2.2 please execute the following::

     ceph config set osd bluefs_preextend_wal_files false

Changelog
~~~~~~~~~
  * bluestore: common/options.cc: disable bluefs_preextend_wal_files

Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-15.2.3.tar.gz
* For packages, see
http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: d289bbdec69ed7c1f516e0a093594580a76b78d0

