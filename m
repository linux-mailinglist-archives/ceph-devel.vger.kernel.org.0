Return-Path: <ceph-devel+bounces-4245-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D4ECF3AF6
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 14:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 47D3C302E322
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 13:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C970341057;
	Mon,  5 Jan 2026 12:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrdgVgxo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B332F547F
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 12:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767617643; cv=none; b=p0bdUgCXMBWJnjKYHrs6F1+5Oc39GquDf92ZJCkvSj02ubXCkCYSOdyu9PAmutfSqCpYKnd2b7GfsaDaRzXtJoK7ID6x+YOVKqRjE58ottwwpCw//KNbANM4rTiIoTOu4ir3ertW9aG1he2TYfcIHMCKO1XgCUfSJwbnUcrN39k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767617643; c=relaxed/simple;
	bh=LDZudQnmCkNFc9pSVjCSenkkXqA70mqbeImeRmLuQAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qztsd7irOHZVs3wM0Q1jHHOTG4fqy9GdV+JHruWw8Kdd6Mci1k5jpMuAMpZcPiEYxJX8CDJNNKg/QJ7I3PhOIcuiN3NLcJH8CAGVdV7+I172YeV6hLRZ6NLLtVY4WDY4cVdVruoe1b2hkbTOBRF2XBXMPxtekNRwHsL9LYBC46w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SrdgVgxo; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0c20ee83dso180219595ad.2
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 04:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767617641; x=1768222441; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCzfFMKfypeQ3TLaSLF6D+ElramHgabrJC77PS6QlA0=;
        b=SrdgVgxof/tvAMCXHJfyN5CEBdRNOQutmdOxyryYCA1jLbg3uRMDBnFoeB9ekiLI4/
         rpoL8SW7BtGoYoL5paCy2GST2CW3i9DYuf4zHVzgVJTXils8I5i/FgfFi0nfAeyOPeGD
         AL8zUNJPKo9vz0DZDBG8ZPasFm1NqcmxmeVUm2QMhWmsKAqScCUZU4QsIN+qDqSpQI0K
         ZnhpoD7G9Vre3/OXRqkdPODiLc6bLiUzQxIrqLczd5HjkkglYw6an7kp1A5iUGtdv6ks
         Kp5a3XoTgW3mw2DAd1kGvuInXb+KvQ1SBmpetejPbgtW/9xjW0mhlRcv79Fwy9yYW6MV
         0VuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767617641; x=1768222441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LCzfFMKfypeQ3TLaSLF6D+ElramHgabrJC77PS6QlA0=;
        b=S8kjYasSj8KHG4iR40l/4T2VPbiweMWAtjgtd7jwgZuclI+OnhMtV/RpHdaAUFJqfE
         jEGRUid8d0K26ZpCcrvXiA9vA8D0QC38wdPj/JNRjDufeCA7n3Ntorv9TMQGfw7AApfo
         4MWumy935UAS0EY1Usoyy+TIAqd6H2U2CxHAv7FohtDyFBiZXI42N5kFtZ0NyBq27HHU
         7zkeKFASozrWbEZ0CvEqZUl9D+4UiRbswCfSHRDtkNjt0ZEsauRnG/xk8YjwosSJW91r
         vywulCehEoPBtsa2vMKaC766TzzeMtKCgaVuNGE063r2KjZwyy3SSV78fYEe6ZYoFBSo
         5fpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCVpUo7P4Uj4uqCmusorM73l+yU96omSIdVD9V4n+NSFWUPsHMaRd+xRjfKbi2sPoQYjQV3rPqMma5@vger.kernel.org
X-Gm-Message-State: AOJu0YzpWciMZ7R6nvzvyF9XWW/PE8oFUv3vDg0kKNT4wIrKpIHPzcNv
	EnZX2hlAe8A7/PE1P6wERp00C93/Xyx44B8h2ldw76JVWo11vW8TijIJNdcxylP237HiHLppscV
	CngHzo+3p9C5uftHsHL8DWpohi/SsELczG/yM
X-Gm-Gg: AY/fxX5g68gcKOwBvEXuvxW39AHF0REOKZ/BLVMLbEyOmuvxD0wujYPbIB8WHfKXRF2
	xxtgaZgHLrdIJtRQggNlM+Ouh1UwjBWKbnghKgxQrWoLa1e6VL/MhSydueSj+JRd6fqy8vNBUWB
	Pw2oplV3V6jtqnFXOX1yljctZqMXaxAXa5QpE7O0kxpjKdnZDTx6WA7bD0MUGWACAZZmdFRQ6vB
	x7JFKcQqcLJjvnNGCKd/MkV/uB3ae+oTVzpecU3sDOAp5NLqilo2tvGZGk6vbHn10i0MwA=
X-Google-Smtp-Source: AGHT+IE98las7bRT2mP/f6K18R01NAWBc4/AsI2kb6IjL6svFcHf/4mfdEum7+2QekzWTQPru1Yznfs6GnNDc+Diaw8=
X-Received: by 2002:a05:7022:7e84:b0:119:e56c:189c with SMTP id
 a92af1059eb24-121722aa627mr47568822c88.4.1767617640932; Mon, 05 Jan 2026
 04:54:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251220181149.46699-1-islituo@gmail.com> <dc95e2dbc1293fe00aea3518443a241b890eef79.camel@ibm.com>
In-Reply-To: <dc95e2dbc1293fe00aea3518443a241b890eef79.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 5 Jan 2026 13:53:49 +0100
X-Gm-Features: AQt7F2rCx-ZZCz-xxUOf3aZjzHnwZ01dnOoBNZwdV6C9HVScS6PL7AHZnL_3QIs
Message-ID: <CAOi1vP9KpasJHGdb78NpboQ1sgkfVNqZ+s-cXVnoho4J52KkqA@mail.gmail.com>
Subject: Re: [PATCH v2] net: ceph: make free_choose_arg_map() resilient to
 partial allocation
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, "islituo@gmail.com" <islituo@gmail.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 24, 2025 at 12:01=E2=80=AFAM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Sun, 2025-12-21 at 02:11 +0800, Tuo Li wrote:
> > free_choose_arg_map() may dereference a NULL pointer if its caller fail=
s
> > after a partial allocation.
> >
> > For example, in decode_choose_args(), if allocation of arg_map->args
> > fails, execution jumps to the fail label and free_choose_arg_map() is
> > called. Since arg_map->size is updated to a non-zero value before memor=
y
> > allocation, free_choose_arg_map() will iterate over arg_map->args and
> > dereference a NULL pointer.
> >
> > To prevent this potential NULL pointer dereference and make
> > free_choose_arg_map() more resilient, add checks for pointers before
> > iterating.
> >
> > Signed-off-by: Tuo Li <islituo@gmail.com>
> > ---
> > v2:
> > * Add pointer checks before iterating in free_choose_arg_map(), instead=
 of
> >   moving the arg_map->size assignment in decode_choose_args().
> >   Thanks to Viacheslav Dubeyko for pointing out the issue with the prev=
ious
> >   patch, and to Ilya Dryomov for the helpful advice.
> > ---
> >  net/ceph/osdmap.c | 20 ++++++++++++--------
> >  1 file changed, 12 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> > index 34b3ab59602f..08157945af43 100644
> > --- a/net/ceph/osdmap.c
> > +++ b/net/ceph/osdmap.c
> > @@ -241,22 +241,26 @@ static struct crush_choose_arg_map *alloc_choose_=
arg_map(void)
> >
> >  static void free_choose_arg_map(struct crush_choose_arg_map *arg_map)
> >  {
> > -     if (arg_map) {
> > -             int i, j;
> > +     int i, j;
> > +
> > +     if (!arg_map)
> > +             return;
> >
> > -             WARN_ON(!RB_EMPTY_NODE(&arg_map->node));
> > +     WARN_ON(!RB_EMPTY_NODE(&arg_map->node));
> >
> > +     if (arg_map->args) {
> >               for (i =3D 0; i < arg_map->size; i++) {
> >                       struct crush_choose_arg *arg =3D &arg_map->args[i=
];
> > -
> > -                     for (j =3D 0; j < arg->weight_set_size; j++)
> > -                             kfree(arg->weight_set[j].weights);
> > -                     kfree(arg->weight_set);
> > +                     if (arg->weight_set) {
> > +                             for (j =3D 0; j < arg->weight_set_size; j=
++)
> > +                                     kfree(arg->weight_set[j].weights)=
;
> > +                             kfree(arg->weight_set);
> > +                     }
> >                       kfree(arg->ids);
> >               }
> >               kfree(arg_map->args);
> > -             kfree(arg_map);
> >       }
> > +     kfree(arg_map);
> >  }
> >
> >  DEFINE_RB_FUNCS(choose_arg_map, struct crush_choose_arg_map, choose_ar=
gs_index,
>
> Looks good. Thanks a lot for the fix.
>
> Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> Thanks,
> Slava.

Applied.

Thanks,

                Ilya

