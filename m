Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63FBB63405
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jul 2019 12:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfGIKNP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Jul 2019 06:13:15 -0400
Received: from mail-yw1-f54.google.com ([209.85.161.54]:38926 "EHLO
        mail-yw1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfGIKNO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Jul 2019 06:13:14 -0400
Received: by mail-yw1-f54.google.com with SMTP id x74so5416138ywx.6
        for <ceph-devel@vger.kernel.org>; Tue, 09 Jul 2019 03:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=J9wlTX3zL0h+hRWFGV16fxqFmVxDUZZG2TcDD5OkPPU=;
        b=JTzBuvwPKwrogmUbt9y4qdqCCOFTUtgb5NRHglOl/UJ7Q7PtPluqdMPNkDlGTC4Ht0
         MBOs1XJSJrHpcuHQxLIwAmR9aZbr8ionZbzy3jmuFWjzO8pwECBySHMBZZW870sb2ysT
         ACMzt5sucbufR9SWNOl8bzuyawbO4LoOHcUEzavwc/KAcqv2Eg3dIWQPoYYUoyvzf5M/
         JW8PfzFNciODVqr0+MPJnjn01I5LJpRQz9CwSAnx2Xb18Y+pTn2woDdBnNTm4liMVdZG
         qzZm9WKbpYmGkFkAo2e5Ko+rIe610m2vZnOoiSXcFR49AGkOF5reHCziHfl95QwBcYSs
         Utlw==
X-Gm-Message-State: APjAAAXPutClH/TLSBfUyMfaVugR6GLEpXCfgKcchIp0EVigiG3ClxX5
        O39DHbU4qbHSz/1nGi8MJTX2tw==
X-Google-Smtp-Source: APXvYqy4kBVlK1K44FjKPHbOJl3EvHfiFBdA+Yyrfet3cC3i2bieOPDwXA0zhtQ+waGd1+tcBttN0w==
X-Received: by 2002:a81:914b:: with SMTP id i72mr13207365ywg.133.1562667193791;
        Tue, 09 Jul 2019 03:13:13 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-43E.dyn6.twc.com. [2606:a000:1100:37d::43e])
        by smtp.gmail.com with ESMTPSA id h7sm5790398ywh.60.2019.07.09.03.13.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 03:13:12 -0700 (PDT)
Message-ID: <35a7c9dce30f557a3be756cfeb15c0e471ae80ce.camel@redhat.com>
Subject: Re: ceph_fsync race with reconnect?
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@newdream.net>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 09 Jul 2019 06:13:11 -0400
In-Reply-To: <CAAM7YA=DW5jYtWkz-gqZ_Eg8ko-sK8mChMGB7yOV=Xz8o=AhLQ@mail.gmail.com>
References: <f93a412ecd6b17389622ac7d0ae9b225921e4163.camel@redhat.com>
         <CAAM7YA=DW5jYtWkz-gqZ_Eg8ko-sK8mChMGB7yOV=Xz8o=AhLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-07-09 at 07:52 +0800, Yan, Zheng wrote:
> On Tue, Jul 9, 2019 at 3:23 AM Jeff Layton <jlayton@redhat.com> wrote:
> > I've been working on a patchset to add inline write support to kcephfs,
> > and have run across a potential race in fsync. I could use someone to
> > sanity check me though since I don't have a great grasp of the MDS
> > session handling:
> > 
> > ceph_fsync() calls try_flush_caps() to flush the dirty metadata back to
> > the MDS when Fw caps are flushed back.  try_flush_caps does this,
> > however:
> > 
> >                 if (cap->session->s_state < CEPH_MDS_SESSION_OPEN) {
> >                         spin_unlock(&ci->i_ceph_lock);
> >                         goto out;
> >                 }
> > 
> 
> enum {
>         CEPH_MDS_SESSION_NEW = 1,
>         CEPH_MDS_SESSION_OPENING = 2,
>         CEPH_MDS_SESSION_OPEN = 3,
>         CEPH_MDS_SESSION_HUNG = 4,
>         CEPH_MDS_SESSION_RESTARTING = 5,
>         CEPH_MDS_SESSION_RECONNECTING = 6,
>         CEPH_MDS_SESSION_CLOSING = 7,
>         CEPH_MDS_SESSION_REJECTED = 8,
> };
> 
> the value of reconnect state is larger than 2
> 

Right, I get that. The big question is whether you can ever move from a
higher state to something less than CEPH_MDS_SESSION_OPEN.

__do_request can do this:

                if (session->s_state == CEPH_MDS_SESSION_NEW ||
                    session->s_state == CEPH_MDS_SESSION_CLOSING)
                        __open_session(mdsc, session);

...and __open_session does this:

        session->s_state = CEPH_MDS_SESSION_OPENING;

...so it sort of looks like you can go from CLOSING(7) to OPENING(2).
That said, I don't have a great feel for the session state transitions,
and don't know whether this is a real possibility.

> 
> > ...at that point, try_flush_caps will return 0, and set *ptid to 0 on
> > the way out. ceph_fsync won't see that Fw is still dirty at that point
> > and won't wait, returning without flushing metadata.
> > 
> > Am I missing something that prevents this? I can open a tracker bug for
> > this if it is a problem, but I wanted to be sure it was a bug before I
> > did so.
> > 
> > Thanks,
> > --
> > Jeff Layton <jlayton@redhat.com>
> > 

-- 
Jeff Layton <jlayton@redhat.com>

