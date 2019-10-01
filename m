Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2950AC3819
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Oct 2019 16:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389287AbfJAOyT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Oct 2019 10:54:19 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:37036 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbfJAOyT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Oct 2019 10:54:19 -0400
Received: by mail-qt1-f172.google.com with SMTP id l3so21969570qtr.4
        for <ceph-devel@vger.kernel.org>; Tue, 01 Oct 2019 07:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OmPlm3FpFedOu9BR249zo48q06X3HJqZp3qfCPAD0Gw=;
        b=pQAUSjJWx0n8mYUFyqpo5dlzN1dv1h8QlvxbPnX0KGTk9QcTmnOBYtdfQT1hcy82xw
         MAfpfLGaEzLwfcLHrAbjKSUR/XiPF4aIttKY9OSWXWz1eIyo7VP7IqZ3IkcASRx/pgVe
         UH5FELWTomezGVcxa2VDM89ynYWGeq64LBEWseQK5SUTHqBJN7myIqBTKHa7pbVMJR6w
         tRqY7mvSbNXZG4gxQIEWmUML9TnKowBqQQE7mmmKSPACxLtOnm6oEWOe/ldz8mLyrTNG
         swin0hh1cczI/wtRpLOJWHfvpkX7VQ2j8M+Kf5n3AmFAj6xjLQ/iPa+hnlEQJOdv1/Qg
         hKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OmPlm3FpFedOu9BR249zo48q06X3HJqZp3qfCPAD0Gw=;
        b=Ngn4Ni38OWs3j2s8toko+VJJ974mYi0pC350ZRiXfDugngWSo02w0dDHKCpT15/pLN
         dUFbs6rxu+EyJYufAGo2YTVOwwAp0aaPg9KXgwb7I8KvRQqiJj9LhW72WqyoPPgOZSGP
         1w/gSddJ1ou6DHeWAakcKxcA2U+lLVT5V9Ylv+BHAyatL76wJiOFinu8aAjPifidwglk
         sOuC9niHc+JyGWIfDc0To2JYPecmdQKeBMSacYw+vTnhUlagKNOVSFRSaKYgigOttYEd
         qN+DGa7wJlVBKXfMhFqRqmfGlDoGxCRRjltp2XzlxhVe+xkZRGhhDcqoCIpPV4zeVdZG
         Koeg==
X-Gm-Message-State: APjAAAV4wIvpovTMrKd/QEoQ1X/hBl6sCkJQci+7m06i0eCV3uhGLesi
        kEMHWBij3qeMQRFdxSGIxHKlKa3furwYDwzSI+nXDg==
X-Google-Smtp-Source: APXvYqwTgDPEUKwno20j8xatcGwTzmsYQkQ3pIlcwqK5dkDRvm10u9q7B+SgsCyvhDoC2nX6DZTAxuWteMEBP5lPv9Y=
X-Received: by 2002:a0c:e785:: with SMTP id x5mr25779057qvn.71.1569941658372;
 Tue, 01 Oct 2019 07:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <qmq36f$5pap$1@blaine.gmane.org> <H000007100150ea4.1569860022.sx.f1-outsourcing.eu*@MHS>
 <CALi_L4-fNi=gP9sOCWPNcok9tVG=K-rtER68n1s9bkZzwuGhEw@mail.gmail.com>
 <CAD9yTbEzPJwAqVgn2fWtjZCG8zFnAgjvtMOnO-+FJd4XQx364Q@mail.gmail.com> <CALi_L4_dzsu3r4FGpc6K6Ce3iz6JAZmKaVTB8LXrLqVNOH1ong@mail.gmail.com>
In-Reply-To: <CALi_L4_dzsu3r4FGpc6K6Ce3iz6JAZmKaVTB8LXrLqVNOH1ong@mail.gmail.com>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Tue, 1 Oct 2019 07:54:06 -0700
Message-ID: <CAANLjFqW6WE_vfYd=39GVV8DgGJge+qBr52tHj+t0P3Aap4rBw@mail.gmail.com>
Subject: Re: [ceph-users] Commit and Apply latency on nautilus
To:     Sasha Litvak <alexander.v.litvak@gmail.com>
Cc:     Paul Emmerich <paul.emmerich@croit.io>,
        ceph-users <ceph-users@lists.ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 30, 2019 at 5:12 PM Sasha Litvak
<alexander.v.litvak@gmail.com> wrote:
>
> At this point, I ran out of ideas.  I changed nr_requests and readahead parameters to 128->1024 and 128->4096, tuned nodes to performance-throughput.  However, I still get high latency during benchmark testing.  I attempted to disable cache on ssd
>
> for i in {a..f}; do hdparm -W 0 -A 0 /dev/sd$i; done
>
> and I think it make things not better at all.  I have H740 and H730 controllers with drives in HBA mode.
>
> Other them converting them one by one to RAID0 I am not sure what else I can try.
>
> Any suggestions?

If you haven't already tried this, add this to your ceph.conf and
restart your OSDs, this should help bring down the variance in latency
(It will be the default in Octopus):

osd op queue = wpq
osd op queue cut off = high

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
