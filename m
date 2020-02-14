Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FBF15F713
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2020 20:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388456AbgBNTrx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Feb 2020 14:47:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54954 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387508AbgBNTrx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 14:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581709671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MU9eJ7Uacc5mnZrNINcW5dEpL191+JV7XTN3mBoMH6E=;
        b=M7/UvSw/T+IHKgeTVFzEtx5iKcRgOHrnpVOx5aQYjr6XT4nfWDBJ4zb2/F+vAgKW3GFkHx
        javKg3xO9Dj7tbymqPtGR6RSAFbqqGBMGbmWKNFZ+aTX1w78kZdTlIFXLW5g+UQ6ZG68c5
        POFO2dET4kez77oX28EIJvIQJz+iOts=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-A-DG73INPZOp7g-sFCmspw-1; Fri, 14 Feb 2020 14:47:49 -0500
X-MC-Unique: A-DG73INPZOp7g-sFCmspw-1
Received: by mail-qk1-f199.google.com with SMTP id z1so6937198qkl.15
        for <ceph-devel@vger.kernel.org>; Fri, 14 Feb 2020 11:47:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=MU9eJ7Uacc5mnZrNINcW5dEpL191+JV7XTN3mBoMH6E=;
        b=fSigzISYvtDGCZRsESUbCLXADXtiTPE7buXfZfN4VRLArcXHsK0JCGl3Z/np3KnIov
         PVRpJqrZyr0T2OJ2clTHIpFu7baYdVHQcP30WD+97qusI91nFzGge/glo0ycfGdmHsHS
         hWovRO9JpFrZGS0CiI4g2p9pvRsomqdb3lAPGErwe0e3nwjsQc/PQbNQRsyjg6l7Rnki
         jpg29BGSSQPZXNQ5l/U6OD9aJm24Ar6BrZqJQ4J7Kl24KTCnuWKbOZoO2pwYFA46trOZ
         pak/CNXTMeLoJ6YgDd/UVdAzATnErJkDJOaRvvWOtmN0HGs18l5sD78c974ZlnZSE3Qn
         3Xiw==
X-Gm-Message-State: APjAAAX8LTPbxEyBvps4C3R92k1UY2ePSrZsnQk0PHo4Ner5l58l3QLh
        rxZv3WMnqz3aVdhwxLGahBkeqb7P/S+OZgZZMeg4L+izSN74DhffQQQrjKFHPq1RLSneJQkY7ve
        0dZF/W6/bmvitNSGyhMVNktm0BzXADhW+A1TNKA==
X-Received: by 2002:a37:887:: with SMTP id 129mr4307713qki.250.1581709669133;
        Fri, 14 Feb 2020 11:47:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqwoqJQmSm7NLxeZdCRyDSn8cUYPjRjGrYmn2EH4qZjOZlBRDARaNIaRk6n7eRMZl4q9RJnpGccAI4HqxRcdNdg=
X-Received: by 2002:a37:887:: with SMTP id 129mr4307699qki.250.1581709668900;
 Fri, 14 Feb 2020 11:47:48 -0800 (PST)
MIME-Version: 1.0
References: <CAMMFjmE4wyKcP0KkudhTu2zeZF+SswZ=kN_k-Xaq1aC6o4vWkQ@mail.gmail.com>
In-Reply-To: <CAMMFjmE4wyKcP0KkudhTu2zeZF+SswZ=kN_k-Xaq1aC6o4vWkQ@mail.gmail.com>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Fri, 14 Feb 2020 11:47:37 -0800
Message-ID: <CAMMFjmGOqAoBYmmFOWFHTw9NrGQEwNLeUPmw2+5RE+LzVMsuYw@mail.gmail.com>
Subject: Re: FYI nautilus branch is locked
To:     Yuri Weinstein <yweinste@redhat.com>, dev@ceph.io,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Abhishek Lekshmanan <abhishek@suse.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Casey Bodley <cbodley@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
        "Durgin, Josh" <jdurgin@redhat.com>,
        David Zafman <dzafman@redhat.com>,
        "Weil, Sage" <sweil@redhat.com>,
        Ramana Venkatesh Raja <rraja@redhat.com>,
        Tamilarasi Muthamizhan <tmuthami@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        David Galloway <dgallowa@redhat.com>,
        Milind Changire <mchangir@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Sorry correction again - 14.2.8

On Fri, Feb 14, 2020 at 11:30 AM Yuri Weinstein <yweinste@redhat.com> wrote:
>
> We are getting ready to test 14.2.9 and nautilus branch is locked for
> merges until it's done.
>
> sah1 - 4d5b84085009968f557baaa4209183f1374773cd
>
> Nathan, Abhishek pls confirm.
>
> Thank you
> YuriW

