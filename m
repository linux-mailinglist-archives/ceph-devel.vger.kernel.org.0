Return-Path: <ceph-devel+bounces-946-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC61186E716
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Mar 2024 18:23:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2D09B2BD9E
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Mar 2024 17:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E2355663;
	Fri,  1 Mar 2024 17:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dzC5V90F"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5863C3F;
	Fri,  1 Mar 2024 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709313368; cv=none; b=OZz1+y3LPh620eTQlQ6u5SdJl87tDbxgCV33r+CScinR9ojCJqNFqWnuCTRWJhGUkvcdmNGjKePtIhglXWSDSPYNi+vM3EUFaCEb37q2bjcBjQGb6bDcaQqKaQ/LG8octWf1p+Kwr+b/u7EUiQK1cardjBrbkepojKbLzgZdaqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709313368; c=relaxed/simple;
	bh=XMVOYBRfT+HrAgV/eTDRRuEKjfYUhfleOi5dPNbhvYY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=owL1OTmDpsMmISvUjN1uJDCV6tueyg0oVCHpMMicaq0DAk30cON0iTn6W0I+0ZjT2YmhPQi3Wacdy0PPrZvAvHo3nqdKr5v+cvT9rIav7hXmGDuYRN5VrJt9PHyjp943xdyRv8SmES/og2uRIP0RXKaPKVAJ/3uW1oSEgBQOdlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dzC5V90F; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5a0e9baaab4so1007182eaf.3;
        Fri, 01 Mar 2024 09:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709313366; x=1709918166; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Zi2SksqhAVYxU/4yxtVr9LwsZmmgo0bbQNXm0oTExU=;
        b=dzC5V90F2ICNzUF7jTdec0/Hc/dE//f5LBzWitMaoaVAXvJKp8VjqFo+zmZRahCpfq
         +j1lsl0Lu7O7Tq1fFf7zsz9F6m/e0cgXhhXisdWdLKPQQIVxP7HQH/F4iyEk7vfw9YzL
         vTEHkHWiJ4uW42Su2zDSTXsiogZfOs6loe1RtcizppWN4gbXXrpmQalwATHV58x45ZSk
         Ki49YgV4B0oIEt8hn/r5RgjAu4L4cEXO8acwMwiHXODoPIY8l9kAVXCw9npgFC7m8X6F
         NqQ4XhSArGdCAPGeCI2X0SjlR6Q0fchznekFBot1YvetgAf4O8i37e1KUlYg3HnrV15K
         vnYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709313366; x=1709918166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Zi2SksqhAVYxU/4yxtVr9LwsZmmgo0bbQNXm0oTExU=;
        b=YOai6xB/K8B/Z2Vz+Kk7wCC3y8TpLZyYC7vDS6mgALH/xlJj11yCb0zPt+Pnga7VdN
         EPunCi0hyapJWGYkgbJ43vCTGdiIQU3w/ndnlV0GcEpBSKShBsviLye4h71QAbMfBlQM
         x1CpCgzcvggqpjuA5MtScZou/eU5lINUtkzUtWp+FYncOqJhd5OGYgY37AxNwB9a2xZc
         FyVtoXcCMaaT7P+u5+laNBDk/A7OvUaqTRp+PnZSBHh3WDNc+nhibEq3at/DYOWd+07Y
         EsJcD6KXfdOAscYRTVvXRa1x+xXYGxiLlOv/y5Ae9TwXRi/UDKRjEAIjj9eL9I2H83lC
         m8nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRoN0bM/YFyAuWiV9wvTKCH2dDFeOkunOjCAVF6mJauOYD+yw/YmE+UPEFdwdh2G5rEq2v/G2RbGIfzcfo7z7naU4ArBFp
X-Gm-Message-State: AOJu0YwgOR1BekFp1Nz7jZG7jI0TDXncRgNMFpy1YPXsZaMw27Llzpam
	un9dxxZiveX5SLz9GMfzCcBrhMyj8/qp9Fqz37fANQc7hoIMKNolKiIXrYH5wTFu14WMWSGcv2j
	kJK9u2SSORR+V9rRUxr6MS5SgGNs=
X-Google-Smtp-Source: AGHT+IGbXqnXMDbnS8IWbH4oJ+F6hGyOtuyQrhD/wd6zlGPCGq83lc2oE3/XXgoaFJm1NBaJKyasvcjFhihXC5QuLa0=
X-Received: by 2002:a4a:650e:0:b0:5a0:ec91:74c3 with SMTP id
 y14-20020a4a650e000000b005a0ec9174c3mr2300613ooc.6.1709313366388; Fri, 01 Mar
 2024 09:16:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229041950.738878-1-xiubli@redhat.com> <CAOi1vP-n34TCcKoLLKe3yXRqS93qT4nc5pkM8Byo-D4zH-KZWA@mail.gmail.com>
 <6c3f5ef9-e350-4a1e-81dd-6ab63e7e5ef3@redhat.com>
In-Reply-To: <6c3f5ef9-e350-4a1e-81dd-6ab63e7e5ef3@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 1 Mar 2024 18:15:54 +0100
Message-ID: <CAOi1vP_WGs4yQz62UaVBDWk-vkcAQ7=SgQG37Zu86Q2QusMgOw@mail.gmail.com>
Subject: Re: [PATCH] libceph: init the cursor when preparing the sparse read
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, stable@vger.kernel.org, 
	Luis Henriques <lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 2:53=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 2/29/24 18:48, Ilya Dryomov wrote:
> > On Thu, Feb 29, 2024 at 5:22=E2=80=AFAM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> The osd code has remove cursor initilizing code and this will make
> >> the sparse read state into a infinite loop. We should initialize
> >> the cursor just before each sparse-read in messnger v2.
> >>
> >> Cc: stable@vger.kernel.org
> >> URL: https://tracker.ceph.com/issues/64607
> >> Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available=
 on the socket")
> >> Reported-by: Luis Henriques <lhenriques@suse.de>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   net/ceph/messenger_v2.c | 3 +++
> >>   1 file changed, 3 insertions(+)
> >>
> >> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> >> index a0ca5414b333..7ae0f80100f4 100644
> >> --- a/net/ceph/messenger_v2.c
> >> +++ b/net/ceph/messenger_v2.c
> >> @@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct ceph_=
connection *con)
> >>   static int prepare_sparse_read_data(struct ceph_connection *con)
> >>   {
> >>          struct ceph_msg *msg =3D con->in_msg;
> >> +       u64 len =3D con->in_msg->sparse_read_total ? : data_len(con->i=
n_msg);
> >>
> >>          dout("%s: starting sparse read\n", __func__);
> >>
> >> @@ -2034,6 +2035,8 @@ static int prepare_sparse_read_data(struct ceph_=
connection *con)
> >>          if (!con_secure(con))
> >>                  con->in_data_crc =3D -1;
> >>
> >> +       ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg, len=
);
> >> +
> >>          reset_in_kvecs(con);
> >>          con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA_CONT;
> >>          con->v2.data_len_remain =3D data_len(msg);
> >> --
> >> 2.43.0
> >>
> > Hi Xiubo,
> >
> > How did this get missed?  Was generic/580 not paired with msgr2 in crc
> > mode or are we not running generic/580 at all?
> >
> > Multiple runs have happened since the patch was staged so if the matrix
> > is set up correctly ms_mode=3Dcrc should have been in effect for xfstes=
ts
> > at least a couple of times.
>
> I just found that my test script is incorrect and missed this case.
>
> The test locally is covered the msgr1 mostly and I think the qa test
> suite also doesn't cover it too. I will try to improve the qa tests later=
.

Could you please provide some details on the fixes needed to address
the coverage gap in the fs suite?  I'm lost because you marked [1] for
backporting to reef as (part of?) the solution, however Venky's job [2]
that is linked there in the tracker is based on main and therefore has
everything.

Additionally, [2] seems to be have failed when installing packages, so
the relationship to [1] isn't obvious to me.

[1] https://tracker.ceph.com/issues/59195
[2] https://pulpito.ceph.com/vshankar-2024-02-27_04:05:06-fs-wip-vshankar-t=
esting-20240226.124304-testing-default-smithi/7574417/

Thanks,

                Ilya

