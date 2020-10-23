Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3942D2978DC
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Oct 2020 23:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756684AbgJWV26 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 23 Oct 2020 17:28:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756681AbgJWV25 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 23 Oct 2020 17:28:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603488535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G6+mbCT+6miI047Hj2jdGIPSOrJHY4SgfbJTHRF0KNE=;
        b=V07Mejvwn1SqUxdZOMu44eIrxDILpVmolEu7Pb88D0bKOqbzC1HPV5zt2e68F7KfqbwdEa
        6uZArUqkKh46VRz9dCFDmTw1Kfva0PsPVqvLPpU6cWT9xe64LbLOc1Pv4BTjm5stBhBc6e
        aHc2pueLP40OwLNxWPVBBsTaEFLnCXk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-L8gMPY90M2--EF5jxyat_g-1; Fri, 23 Oct 2020 17:28:51 -0400
X-MC-Unique: L8gMPY90M2--EF5jxyat_g-1
Received: by mail-io1-f71.google.com with SMTP id j21so2459936iog.8
        for <ceph-devel@vger.kernel.org>; Fri, 23 Oct 2020 14:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G6+mbCT+6miI047Hj2jdGIPSOrJHY4SgfbJTHRF0KNE=;
        b=r3FBFUle0hih2Xn6ybwDWrFQoQJ/PHaWWcMTd12Hbqhx0RcWobNsi2G9i1D/IgLH9H
         Y6KdOEK5y1qcHIjCr/GYEeYX7rn5VxCWTeAjlUfksjd0b7N78BjA8OyIpPgSrJhy8X3P
         iryW25DJYsfrN6wIcmVvuE/l+ApEd/9WhLJqdUCN/qOW2p3C0ZH9PTI6+CCdQ72/uaM8
         viVrJj3vQt54ZnrbA2G+jmzAADSzIPEWVi9g8Rg5FZpKeh8pO1recMCwYyeTAlip4c0d
         FNKs4KLUAvzlWq0RxKZrJHQIs8Yk9yOqomQSX2kv3QGGNNbBnh0LMD2vmYbAD9YfyrbC
         8q/g==
X-Gm-Message-State: AOAM533U7NDrOHGzrvbPw2XE4wzHP/efO68DTpcCJDu7MhYOD5Oti+yH
        W6dnpu6g4/KuIkr3B8cTHUkNnxhaEtDNVxpSaSIL7nPxzZY8RvLxUU/y9ZU7JQNj5lQj7qu6KR6
        l04SGQfPNqQRVVcjPkZI8IA438dNXKSZSGTg6hQ==
X-Received: by 2002:a02:a181:: with SMTP id n1mr3422378jah.119.1603488531165;
        Fri, 23 Oct 2020 14:28:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVNRnEfWQ8yKuz/0v7q4S2lxoyhvwbrhEp/1BdOCPE5gzwLk0AEXbuzewvptdOl/RA9pSHgOmGRTqujx8uxPk=
X-Received: by 2002:a02:a181:: with SMTP id n1mr3422364jah.119.1603488530949;
 Fri, 23 Oct 2020 14:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <CACo-D_AU21TT6wcuUXTDquUY1UtSb265ga+0SAvU2S-RCWmzTw@mail.gmail.com>
 <CABZ+qq=n8XFYNtrJKThG3OViYa12pVMU4b5eVr58ZFHxbAod=A@mail.gmail.com>
 <CACo-D_DhNDXAyOjJR6W9JYhZP7m9pfbh7q-G1nDMJhHskdtOXQ@mail.gmail.com>
 <CABZ+qqk1ii6sjK4izGb-ReZdUDy4U-7gRj6ywFxzHkpEGuOOHQ@mail.gmail.com>
 <CACo-D_D6abDxhwUY2ZdkFbdwTPduhKbvtK7+7GFL5VWQJbZ7xw@mail.gmail.com>
 <CABZ+qqkB_daQ+yfq+CR3Ye+8t+gv_QuavNWNRJzxP6Og5VKROg@mail.gmail.com>
 <CACo-D_BxGq2-Dq6FahNXPN6rj3BeoKmJuq6j5Nhqzcx74URqHg@mail.gmail.com>
 <CABZ+qqmvn-Yd3ZhPd3q4-RFtqjGgeHLCMwVvjMLJ4fmtxY9-gA@mail.gmail.com>
 <1867678ff367465eb7a6767a62b45764@dtu.dk> <CACo-D_Cjb0TF47ZwYYAXkpnYWN-9eAXtc4K3fGaC=ZLUvHzLRA@mail.gmail.com>
 <CABZ+qqn6FJGU_a7-+Qiqt0YxbfMxN-Bj8X_kcfD+X8P6idRCmA@mail.gmail.com>
 <CACo-D_DCHENXaPntE_T+R7L7yfUVMx9K-KHu40oyd-dKPc_kEg@mail.gmail.com>
 <CABZ+qqkGQKHx=VzvDVjDvG_m7C8PpfbiuRM3+-b5_8yLwgNbFg@mail.gmail.com>
 <29f9da3105b34397bbaf59471a448077@dtu.dk> <CACo-D_BoBo5YdujToR_Tpu9FkUny5B9eTa=vPHHXaHQtPZKv9A@mail.gmail.com>
In-Reply-To: <CACo-D_BoBo5YdujToR_Tpu9FkUny5B9eTa=vPHHXaHQtPZKv9A@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 23 Oct 2020 14:28:24 -0700
Message-ID: <CA+2bHPZW0Aoj1bVe6+Q_N9DPMa8pYqz87bExT48STGktZCYn0w@mail.gmail.com>
Subject: Re: [ceph-users] Re: Urgent help needed please - MDS offline
To:     David C <dcsysengineer@gmail.com>
Cc:     Frank Schilder <frans@dtu.dk>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Oct 23, 2020 at 9:02 AM David C <dcsysengineer@gmail.com> wrote:
>
> Success!
>
> I remembered I had a server I'd taken out of the cluster to
> investigate some issues, that had some good quality 800GB Intel DC
> SSDs, dedicated an entire drive to swap, tuned up min_free_kbytes,
> added an MDS to that server and let it run. Took 3 - 4 hours but
> eventually came back online. It used the 128GB of RAM and about 250GB
> of the swap.
>
> Dan, thanks so much for steering me down this path, I would have more
> than likely started hacking away at the journal otherwise!
>
> Frank, thanks for pointing me towards that other thread, I used your
> min_free_kbytes tip
>
> I now need to consider updating - I wonder if the risk averse CephFS
> operator would go for the latest Nautilus or latest Octopus, it used
> to be that the newer CephFS code meant the most stable but don't know
> if that's still the case.

You need to first upgrade to Nautilus in any case. n+2 releases is the
max delta between upgrades.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

