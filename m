Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 479B0750E5
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 16:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387957AbfGYOXm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 10:23:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43619 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbfGYOXm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Jul 2019 10:23:42 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so10861682qka.10
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 07:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VBsgIpqwWEqis6hBjcYl7+ODgfCpIQJHtdHdRFPufzE=;
        b=HiVnG0b92IEYQ70KSSiyOL+iGC36YN3PiYYlXp0r22RUp98aiFrO6vvzer/EXVjB1V
         Zwz6C0gJyO4Dk656dOP3xr0U2U4uCIGSEnGmu7com0GTWkylakGvnUi1DxW+ANz5l4Q4
         CsRHlR76mzi+eG7SgdiUA75VQz+0weMAd/dqB0Sz7/qDBzlCjfkWOoMwMLGXvKDEhRJ/
         +m6k4tUPJmD3DGcUmuCvNdw/CD1QVOLzL/uCMi3dTqMJESC/OK2Dnf/uXMD2YVtsyym4
         iHXLLUJ8/XypYOCQesWzOhrGq5Y/Sm+a4Mv6nWId2oWfHr4WZaVYJI3A/zuTf2L+5jno
         Oy+Q==
X-Gm-Message-State: APjAAAXjXEse4zpzGPbuItq0UQonL5GR8HR6bMCsOcjfQGEbufuMErRs
        SZDPbEwB5n7n7N5vt/qBsWbJ9wIOEVMdUrcE+XrxLg==
X-Google-Smtp-Source: APXvYqzmBYCd7w6R0kFGsMbtmBn3BqUHOGLOop2BO2FVQeXRiuLkNEybOHKYwy3/TWKRMGE4l5h8rXCauMkU5LsXXoM=
X-Received: by 2002:a37:61c3:: with SMTP id v186mr55855312qkb.158.1564064621837;
 Thu, 25 Jul 2019 07:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190724122120.17438-1-zyan@redhat.com> <20190724122120.17438-10-zyan@redhat.com>
In-Reply-To: <20190724122120.17438-10-zyan@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 25 Jul 2019 07:23:16 -0700
Message-ID: <CA+2bHPa9yY9N8J25+fnjUjAX_HNHQMAmjSmTF=z4+hZmf=DZQg@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] ceph: auto reconnect after blacklisted
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 24, 2019 at 5:22 AM Yan, Zheng <zyan@redhat.com> wrote:
>
> Make client use osd reply and session message to infer if itself is
> blacklisted. Client reconnect to cluster using new entity addr if it
> is blacklisted. Auto reconnect is limited to once every 30 minutes.

Can we make the 30 minutes limit configurable with a mount option?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
