Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2256DEEEC
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 10:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjDLIq1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 04:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjDLIqX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 04:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342DB7EE3
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 01:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681289070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JDjF7SZHJ+g1/jxzg5qWEkIe9fgV967L+eiIGv3+t5s=;
        b=VXVPZFkKbiejZl33jYg2ek0UklaBR6B4YgVd0OPRhJ47MF4rKXPR9+flBxwKrAkSAqfHhm
        zDqAECBjOfwPta5aBd/1RRPBfU4ijhbdF9mc2YSdl25814Cg2K0YJvN5LhK4SFO9q8CKiW
        iW3695mH1Bwlkg+SPLrR5nP+LlD+Pvk=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-mF6lwfNTNEyyStKEUu3ZpA-1; Wed, 12 Apr 2023 04:44:29 -0400
X-MC-Unique: mF6lwfNTNEyyStKEUu3ZpA-1
Received: by mail-oo1-f72.google.com with SMTP id k3-20020a4a9483000000b00541aa021802so4045240ooi.7
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 01:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681289069; x=1683881069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JDjF7SZHJ+g1/jxzg5qWEkIe9fgV967L+eiIGv3+t5s=;
        b=HD0FzD5JOt3wbQmDRbgvr5bQviVI76JCxPdJVe8kBwbq+phIjnv5Nl1GRK6PAgPmuW
         0O6HDmPq2rnoHXEl0HjQI44WBdyaSv7xg/RV+6aFvWmkn+Ey2ti1oziBnOxHegkgJ5+l
         pnqPU0Ivy+BM6XrCaAllO8ZQXD+Fj54GYI/8EYOulyXuWfjF1FmMKaytNwjv1FUkeC1x
         i/6TP/bmwua3ewsHXAgYPKyDjSQLGtUYWiIntWmLCA0KWjd05RbLP6+zwvvMvfy7ptCr
         fy6pXEUqGC5a5HToYb/uhZXJp2kmGVRarOIYMrST6HUKFHUhNwBHTq/N40xuhdPgEm5x
         Avqw==
X-Gm-Message-State: AAQBX9fVl5VwfR1lykQgxYPjFsF7BHwFQ89ylZQs9zRW02SsfgwGNbjR
        DiGZoljlfoWL93UivzNMUX/vQB+fulpN7cWIRH9m45kJufDovQWzRXcBelSiBLLXxKrudh213bv
        YH/MV2Z5+uCMJIBdW3c7gaWhQ2BVCkDvP89vfQA==
X-Received: by 2002:a05:6808:9b2:b0:38b:f7fa:40ac with SMTP id e18-20020a05680809b200b0038bf7fa40acmr155708oig.8.1681289068970;
        Wed, 12 Apr 2023 01:44:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350bd5KihRJqkAoAkMdVu3aOJMN7xCryZXeFaF3vVSRRStAv6AlzqihQP6vn/sHS3EZjqPMesui86yK+g3YLk1AI=
X-Received: by 2002:a05:6808:9b2:b0:38b:f7fa:40ac with SMTP id
 e18-20020a05680809b200b0038bf7fa40acmr155702oig.8.1681289068767; Wed, 12 Apr
 2023 01:44:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230323065525.201322-1-xiubli@redhat.com> <87wn2t3uqz.fsf@suse.de>
 <b1512c60-bd87-769a-2402-1c33618d2709@redhat.com>
In-Reply-To: <b1512c60-bd87-769a-2402-1c33618d2709@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 12 Apr 2023 14:13:52 +0530
Message-ID: <CACPzV1=r4Tm=hr46r1dhXVND7j1AVLKvjnjQ8sUj9XRSdLXXFg@mail.gmail.com>
Subject: Re: [PATCH v17 00/71] ceph+fscrypt: full support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>,
        idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Apr 4, 2023 at 6:12=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 4/3/23 22:28, Lu=C3=ADs Henriques wrote:
> > xiubli@redhat.com writes:
> >
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> This patch series is based on Jeff Layton's previous great work and ef=
fort
> >> on this and all the patches bas been in the testing branch since this
> >> Monday(20 Mar)
> > I've been going through this new rev[1] in the last few days and I
> > couldn't find any issues with it.  The rebase on top of 6.3 added minor
> > changes since last version (for example, there's no need to call
> > fscrypt_add_test_dummy_key() anymore), but everything seems to be fine.
> >
> > So, FWIW, feel free to add my:
> >
> > Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> > Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> >
> > to the whole series.
> >
> > And, again, thanks a lot for your work on this!
> >
> > [1] Actually, I've looked into what's currently in the 'testing' branch=
,
> > which is already slightly different from this v17.
>
> Yeah, as we discussed in another thread, I have fixed one patch and push
> it to the testing branch, this should be the difference.
>
> Thanks Luis very much.
>
> - Xiubo
>
>
> > Cheers,
>

Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky

