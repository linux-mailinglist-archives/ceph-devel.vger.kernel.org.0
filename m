Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0C661FF9
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Jul 2019 16:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbfGHOCP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Jul 2019 10:02:15 -0400
Received: from mail-yw1-f41.google.com ([209.85.161.41]:34856 "EHLO
        mail-yw1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbfGHOCP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Jul 2019 10:02:15 -0400
Received: by mail-yw1-f41.google.com with SMTP id o7so4435216ywi.2
        for <ceph-devel@vger.kernel.org>; Mon, 08 Jul 2019 07:02:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=yoDwpfjrWpALxiXmQ8oob0PEis7aklvJdMv2TcHcARo=;
        b=YC0ahxydeelgDLoCHLz09jwBY5mgt4DE/u/NpCVcqiwRDABZ/tP0Fqc7o9uamfKAYt
         4SgRaSrIkwnEr5pcovDCJKnkT1B7SmyayA3JdkuqwKuwWH4ITnEv6QEU0DFOGOq9xOV0
         fwXMBTEql/mX0OsRjiMGkd9vLg6/75RVpc3afEt+hyw+SYYSiYzqAwxumfvm78+GaP48
         A5TgOq+kkCIaFVZf4hWffhorbs2OUdp3oKutA6811haxABlcQHVB04YKCKBSsMtSAB+0
         vRAHCdzksGpYPq4qWLFRbx6Kpx4DqN2/F1LZjNFzSg/iVASCuTpRsqjvS7CjfVEqPg3O
         4GyA==
X-Gm-Message-State: APjAAAUUhVsIHMTLGT/L4l908ez5XMTfx13bAmRCLhnPdZZWW7ley6hR
        ajbHehCaoCy3PszsXDBiPsUgyA==
X-Google-Smtp-Source: APXvYqxKSjlzBuhFqdwcjJwKVs0JWKBEjyMTz3YUjDNkFoMemjrrP0BtabRdJymXBa3F53mmiiZm6w==
X-Received: by 2002:a81:1d84:: with SMTP id d126mr4034134ywd.199.1562594534084;
        Mon, 08 Jul 2019 07:02:14 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-43E.dyn6.twc.com. [2606:a000:1100:37d::43e])
        by smtp.gmail.com with ESMTPSA id g189sm5418488ywa.20.2019.07.08.07.02.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 07:02:13 -0700 (PDT)
Message-ID: <f93a412ecd6b17389622ac7d0ae9b225921e4163.camel@redhat.com>
Subject: ceph_fsync race with reconnect?
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     Sage Weil <sage@newdream.net>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 08 Jul 2019 10:02:12 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I've been working on a patchset to add inline write support to kcephfs,
and have run across a potential race in fsync. I could use someone to
sanity check me though since I don't have a great grasp of the MDS
session handling:

ceph_fsync() calls try_flush_caps() to flush the dirty metadata back to
the MDS when Fw caps are flushed back.  try_flush_caps does this,
however:

                if (cap->session->s_state < CEPH_MDS_SESSION_OPEN) {
                        spin_unlock(&ci->i_ceph_lock);
                        goto out;
                }

...at that point, try_flush_caps will return 0, and set *ptid to 0 on
the way out. ceph_fsync won't see that Fw is still dirty at that point
and won't wait, returning without flushing metadata.

Am I missing something that prevents this? I can open a tracker bug for
this if it is a problem, but I wanted to be sure it was a bug before I
did so.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

