Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BDC33E9C9
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Mar 2021 07:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCQGeM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Mar 2021 02:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCQGdd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 Mar 2021 02:33:33 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8A7C06175F
        for <ceph-devel@vger.kernel.org>; Tue, 16 Mar 2021 23:33:33 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id x29so24192814pgk.6
        for <ceph-devel@vger.kernel.org>; Tue, 16 Mar 2021 23:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Kk+tqqseB5Nh19m1UTh43i5B0EQ/mLRppUOVT2Ufi0I=;
        b=nrifkhKqxiWoE2qp810srqEsfKVyVeAF10LD+9TLATM5kCH9HOaqdQoGR5bK+HNXpn
         48gmHeerg/Akmxn8BSidsynYldg8tMTTuWs+p+yWMJIuuvxYzP+MXhUi+B1GSYimsfHr
         1bAmCokp00pLzLclNg2FMb29S9OcIgGFW8+goQTTVJmNtCHt+I2YTdoU0BFzwkBY/Lt0
         rwghAbwmPLWDzVss1pOss55HvAvhwn9vevX+TKL1tbGIWgbk+RZRZwfdNFszeLfA7CPA
         8bw54X/0C8b7zHELUyNvg4x7KUOmBXdpFRbJ2qxSrRlzfWek8N6J4cFrIh59Z2GKEAms
         kF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=Kk+tqqseB5Nh19m1UTh43i5B0EQ/mLRppUOVT2Ufi0I=;
        b=sGIvWG9GSdJo8LfAzQHGGh98XLotQ8aY4Uwj41L5sis9tJpTiZ34O39yr9Yx9CWFox
         TssWEkNfGFl2h5YQ+ySByfdZn4kwO1k/VCbFophsxeg9QxwU5h47YmtZKeOhdtcxWVVK
         kKCd2SRDmdysvdUpOpOybze/DknQKrioYoWgYL6Zwrl9CE+FnrFpnbjs90pAVvfZ1uWw
         LVCyqeMMcSfySdR7cagodQG7wWxweIsfQZOpp2ro2e/sIQ5oTMxDXxaKgW45OvQI3Rxa
         ygoOfAW2RSis8y0PA/Wz2AJmrAhWDMFFyCZeIj/0v1J8/nu9bU/XSZ0aOCHI4tzqW+ys
         Hasg==
X-Gm-Message-State: AOAM531cLrpYr1XEJhtklyVt2Xpb+1P1IDLYGIxAUNLTKLUqbDaTLzye
        JLfO6jjVXPWg6Ulg8c7AMw/yQCATnUTt0FeENvSaHUdO4VIRqg==
X-Google-Smtp-Source: ABdhPJwx0XxW5grqasP1xrufQ78GXB94IrHj4c3q1wjqevRwAuf0sDcz0/2hdPkDBhI+olNfH7VXUQWB2ccuRGZBcNo=
X-Received: by 2002:a62:7bc4:0:b029:1f1:58ea:4010 with SMTP id
 w187-20020a627bc40000b02901f158ea4010mr2894913pfc.70.1615962812813; Tue, 16
 Mar 2021 23:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAPy+zYVsiBspbi28VauMszHRn=a1bqLD06+bTxvvAhXN==5ixQ@mail.gmail.com>
 <CAPy+zYW17u=5mnyx33jODXdMyEQ2dnHWRUHtVW_xmu9+zmSnVA@mail.gmail.com>
In-Reply-To: <CAPy+zYW17u=5mnyx33jODXdMyEQ2dnHWRUHtVW_xmu9+zmSnVA@mail.gmail.com>
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Wed, 17 Mar 2021 14:33:19 +0800
Message-ID: <CAPy+zYVvSROysnYYc+B7TdLMF08U-iHRQD=WHwZJQCE77uf4NA@mail.gmail.com>
Subject: Re: In the ceph multisite master-zone, read ,write,delete objects,
 and the master-zone has data remaining.
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

maybe 'If the bucket about the rgwA instance is
not in the incremental synchronization state, can we prohibit rgwA
from deleting object1?' is not the way to solve the problem. who can help m=
e?

WeiGuo Ren <rwg1335252904@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8816=E6=
=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=8810:04=E5=86=99=E9=81=93=EF=BC=9A
>
> Do we need to solve this problem?
>
> WeiGuo Ren <rwg1335252904@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8810=
=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=884:34=E5=86=99=E9=81=93=EF=BC=
=9A
> >
> > In my test environment, the ceph version is v14.2.5, and there are two
> > rgws, which are instances of two zones, respectively rgwA
> > (master-zone) and rgwB (slave-zone). Cosbench reads, writes, and
> > deletes to rgwA. , The final result rgwA has data residue, but rgwB
> > has no residue.
> >
> > Looking at the log later, I found that this happened:
> > 1. When rgwA deletes the object, the rgwA instance has not yet started
> > datasync (or the process is slow) to synchronize the object in the
> > slave-zone.
> > 2. When rgwA starts data synchronization, rgwB has not deleted the obje=
ct.
> > In process 2, rgwA will retrieve the object from the slave-zone, and
> > then rgwA will enter the incremental synchronization state to
> > synchronize the bilog, but the bilog about the del object will be
> > filtered out, because syncs_trace has  master zone.
> >
> > Below I did a similar reproducing operation (both in the master
> > version and ceph 14.2.5)
> > rgwA and rgwB are two zones of the same zonegroup .rgwA and rgwB is
> > running ( set rgw_run_sync_thread=3Dtrue)
> > rgwA and rgwB are two zones of the same zonegroup .rgwA and rgwB is
> > running ( set rgw_run_sync_thread=3Dtrue)
> > t1: rgwA set rgw_run_sync_thread=3Dfalse and restart it for it to take
> > effect. We use s3cmd to create a bucket in rgwA. And upload an object1
> > in rgwA. We use s3cmd to observe whether object1 has been synchronized
> > in rgwB. or  look radosgw-admin bucket sync status is cauht up it. If
> > the synchronization has passed, proceed to the next step.
> > t2:rgwB set rgw_run_sync_thread=3Dfalse and restart it for it to take
> > effect. rgwA delete object1 .
> > t3:rgwA set rgw_run_sync_thread=3Dtrue and restart it for it to take
> > effect. LOOK radosgw-admin bucket sync status is cauht up it.
> > t4: rgwB set rgw_run_sync_thread=3Dtrue and restart it for it to take
> > effect. LOOK radosgw-admin bucket sync status is cauht up it .
> > The reslut: rgwA has object1,rgwB dosen't have object1.
> > This URL mentioned this problem  https://tracker.ceph.com/issues/47555
> >
> > Could someone can help me? or If the bucket about the rgwA instance is
> > not in the incremental synchronization state, can we prohibit rgwA
> > from deleting object1?
