Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59398275F07
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Sep 2020 19:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgIWRqf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Sep 2020 13:46:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWRqf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 13:46:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600883194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qiFXF241f9HzGMM4wXsK7NLIond0skn/qjeGBkT4Lyw=;
        b=TyAQe4dvxQCYOK73gGV1kh2iQ/FaSkT6CLLS9VqgJFfkF1OOcxZDGqQqFm2/F7zz8lKtSL
        CDHhEfO/PMBYC0/kv3CAna7ytOh46R4nv417vTPoQuBW5Vx8FCQalAHo43w1ynh6saOi5d
        N19UxknA/yxZM2/uySwMOqb6oKXdi9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-MAXqEKvMOoudL-gqFjjfQg-1; Wed, 23 Sep 2020 13:46:18 -0400
X-MC-Unique: MAXqEKvMOoudL-gqFjjfQg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D21F9CC00
        for <ceph-devel@vger.kernel.org>; Wed, 23 Sep 2020 17:46:18 +0000 (UTC)
Received: from [10.3.112.217] (ovpn-112-217.phx2.redhat.com [10.3.112.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D097C55783
        for <ceph-devel@vger.kernel.org>; Wed, 23 Sep 2020 17:46:17 +0000 (UTC)
To:     Ceph Development <ceph-devel@vger.kernel.org>
From:   Mark Nelson <mnelson@redhat.com>
Subject: reminder: Performance meeting paper discussion tomorrow
Message-ID: <bd082db6-5c1e-998f-5c2d-9c20c3740230@redhat.com>
Date:   Wed, 23 Sep 2020 12:46:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Folks,


This is Just a reminder that tomorrow we are going to discuss a paper 
from FAST20 discussing "Characterizing, Modeling, and Benchmarking 
RocksDB Key-Value Workloads at Facebook".  Link is here: 
https://www.usenix.org/system/files/fast20-cao_zhichao.pdf


See everyone tomorrow morning at 8AM PST!


Etherpad:

https://pad.ceph.com/p/performance_weekly

Bluejeans:

https://bluejeans.com/908675367


Mark

