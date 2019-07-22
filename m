Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C437054D
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jul 2019 18:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfGVQVn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Jul 2019 12:21:43 -0400
Received: from mail-yb1-f180.google.com ([209.85.219.180]:32894 "EHLO
        mail-yb1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbfGVQVn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 22 Jul 2019 12:21:43 -0400
Received: by mail-yb1-f180.google.com with SMTP id c202so13807468ybf.0
        for <ceph-devel@vger.kernel.org>; Mon, 22 Jul 2019 09:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=HlBQiyjZnWaOWwgjYgrCE3QkNbgjgfCSJcMxFvt2Syc=;
        b=qaTkWaH7y94h2mlbGRSaolsOGOZgKhGc4xTrWijESxd0t+JOtby0r1iM9Ir1YYRTZs
         R88hwm0tSFV2ljuwWtQ+QoASF/iz3YVwkLVwG372/aJ5IvbmmvCX65pGLs65hY0Ux+9W
         m6Y6+5D8H3LgHPDN0csDFDrPi0BoE80llaDOjGcAPi7/HB1ZGqPjBB7GwtN7A4wtbavr
         7DWhX/nyXk5Pi3U48/KbyRBjKNpu0fcdQNlnnEomtbEA7MQrYwOfRq1LKvIAZSdCWLZ1
         BCKV8WA7PfJDO2Cvfn6f+UxQbbDgm6EICSsCdDhOEgmLB5GEvtYx1qWn2//8+htJnY6Y
         lLbw==
X-Gm-Message-State: APjAAAVAQsy6FsEFrvRDpODPYTqG+Hfk3C4NE2ZWsL6hTaN9q1n01ZBQ
        JXeHdCCH7QTrOnTiyVPw6iFBXIX2kAg=
X-Google-Smtp-Source: APXvYqxX1K2NicZLeNoUEyF/WpLd2KfzVmsg90EJq+qQOPGbNEKY3wZ+niD2FAsboRBg5aUNRP9g5A==
X-Received: by 2002:a25:aaea:: with SMTP id t97mr42157417ybi.126.1563812502291;
        Mon, 22 Jul 2019 09:21:42 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-62B.dyn6.twc.com. [2606:a000:1100:37d::62b])
        by smtp.gmail.com with ESMTPSA id q83sm9652749ywq.88.2019.07.22.09.21.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 09:21:41 -0700 (PDT)
Message-ID: <0d71a1419ed8bedb55e0368139052a8ff527891d.camel@redhat.com>
Subject: is anyone using cephfs inline_data support?
From:   Jeff Layton <jlayton@redhat.com>
To:     ceph-users <ceph-users@ceph.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "dev@ceph.io" <dev@ceph.io>
Date:   Mon, 22 Jul 2019 12:21:40 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

A broad question for the cephfs user community:

I've been looking at adding inline_data write support for kcephfs [1].
It's non-trivial to handle correctly in the kernel (due to the more
complex locking, primarily), and I'm finding some bugs in what's already
there.

Is anyone actually enabling inline_data in their environments? Is this
something we should be expending effort to support?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

[1]: http://docs.ceph.com/docs/master/cephfs/experimental-features/#inline-data


